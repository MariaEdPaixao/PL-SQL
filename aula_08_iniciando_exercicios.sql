-- Maria Eduarda Alves da Paixão - RM558832

-- 1? fun?ao ? fnc_percentual_desconto
 
-- inner join, garantindo que vai ter dos dois lados

CREATE OR REPLACE FUNCTION fnc_percentual_desconto (
    f_cod_pedido NUMBER
) RETURN NUMBER IS
    me_erro EXCEPTION;
    v_itens       NUMBER;
    perc_desconto NUMBER;
BEGIN
    SELECT
        COUNT(b.cod_pedido),
        round((a.val_desconto /(a.val_total_pedido + a.val_desconto)) * 100, 2)
    INTO
        v_itens,
        perc_desconto
    FROM
             pedido a
        INNER JOIN item_pedido b ON ( a.cod_pedido = b.cod_pedido )
    WHERE
        a.cod_pedido = f_cod_pedido
    GROUP BY
        a.cod_pedido,
        a.val_total_pedido,
        a.val_desconto;
        
    IF v_itens = 0 THEN
        RAISE me_erro;
    END IF;
 
    RETURN perc_desconto;

EXCEPTION
 
    WHEN no_data_found THEN 
        raise_application_error(-20002, 'ERRO! Esse pedido não existe');
    WHEN zero_divide THEN
        raise_application_error(-20003, 'ERRO! Tentativa de divisão por zero.');
    WHEN program_error THEN
        raise_application_error(-20004, 'ERRO inesperado no programa.');
    WHEN me_erro THEN
        raise_application_error(-20005, 'ERRO! Pedido sem itens.');
    WHEN OTHERS THEN
        raise_application_error(-20006, 'Erro desconhecido: ' || sqlerrm);

END fnc_percentual_desconto;
 
 
-- testando a fun??o 
SELECT
    fnc_percentual_desconto(130777)
FROM
    dual;

-- 2° função - fnc_media_itens_por_pedido
 
CREATE OR REPLACE FUNCTION fnc_media_itens_por_pedido RETURN NUMBER IS
    quantidade_itens NUMBER;
    v_total_itens    NUMBER;
    v_total_pedidos  NUMBER;
    me_erro EXCEPTION;
BEGIN 
    SELECT
        SUM(b.qtd_item),
        COUNT(DISTINCT a.cod_pedido)
    INTO
        v_total_itens,
        v_total_pedidos
    FROM
             pedido a
        INNER JOIN item_pedido      b ON a.cod_pedido = b.cod_pedido
        INNER JOIN historico_pedido c ON a.cod_pedido = c.cod_pedido;
 
    IF v_total_pedidos = 0 THEN
        RAISE me_erro;
    END IF;

    quantidade_itens := round(v_total_itens / v_total_pedidos, 2); 
    RETURN quantidade_itens;
 
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20002, 'ERRO! Nenhum pedido encontrado');
    WHEN zero_divide THEN
        raise_application_error(-20003, 'ERRO! Tentativa de divisão por zero.');
    WHEN program_error THEN
        raise_application_error(-20004, 'ERRO inesperado no programa.');
    WHEN me_erro THEN
        raise_application_error(-20003, 'ERRO! Tentativa de divisão por zero.');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || sqlerrm);
END fnc_media_itens_por_pedido;

SELECT
    fnc_media_itens_por_pedido
FROM
    dual;

-- 3° procedure - prc_relatorio_estoque_produto
 
CREATE OR REPLACE PROCEDURE prc_relatorio_estoque_produto (
    p_cod_produto NUMBER
) IS
    total_unidades        NUMBER;
    data_max_movimentacao DATE;
    me_erro EXCEPTION;
BEGIN
    SELECT
        SUM(a.qtd_movimentacao_estoque),
        MAX(a.dat_movimento_estoque)
    INTO
        total_unidades,
        data_max_movimentacao
    FROM
        movimento_estoque a
        LEFT JOIN produto_composto  b ON a.cod_produto = b.cod_produto
    WHERE
        a.cod_produto = p_cod_produto;

    IF total_unidades IS NULL AND data_max_movimentacao IS NULL
    THEN
        RAISE me_erro;
    END IF;
 
    dbms_output.put_line('Código do produto: ' || p_cod_produto);
    dbms_output.put_line('Data da última movimentação: ' || data_max_movimentacao);
    dbms_output.put_line('Total de unidades movimentadas: ' || total_unidades);
 
EXCEPTION
    WHEN me_erro THEN
        dbms_output.put_line('ERRO! Não há movimentações referente a esse produto');
    WHEN program_error THEN
        raise_application_error(-20002, 'Erro no servidor!');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || sqlerrm);
END;

CALL prc_relatorio_estoque_produto(25);

-- 4° procedure - prc_relatorio_composicao_ativa

CREATE OR REPLACE PROCEDURE prc_relatorio_estoque_produto (
    p_cod_produto NUMBER
) IS
BEGIN
    FOR i in (
        SELECT
            a.cod_produto_relacionado,
            a.dat_cadastro,
            a.qtd_produto_relacionado,
            SUM(b.qtd_movimentacao_estoque) AS total_movimentacao
        FROM
            produto_composto a
            JOIN movimento_estoque b ON a.cod_produto_relacionado = b.cod_produto
        WHERE
            a.cod_produto = p_cod_produto
            AND
            a.sta_ativo = 'S'
        GROUP BY
            a.cod_produto_relacionado,
            a.dat_cadastro,
            a.qtd_produto_relacionado

    ) LOOP
 
       dbms_output.put_line('Código do produto: ' || p_cod_produto);
       dbms_output.put_line('Código do produto relacionado: ' || i.cod_produto_relacionado);
       dbms_output.put_line('Quantidade de produtos relacionados: ' || i.qtd_produto_relacionado);
       dbms_output.put_line('Total de movimentação: ' || i.total_movimentacao);
       dbms_output.put_line('Data de cadastro: ' ||i.dat_cadastro);
       dbms_output.put_line('-----------------------------------------------');
    END LOOP;
EXCEPTION
    WHEN program_error THEN
        raise_application_error(-20002, 'Erro no servidor!'); 
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END;

CALL prc_relatorio_estoque_produto(25);
 
-- 5° procedure - prc_relatorio_pedido

CREATE OR REPLACE PROCEDURE prc_relatorio_pedido (
    p_cod_pedido NUMBER

) IS
    v_status_label VARCHAR2(20);
    v_found BOOLEAN := FALSE;
BEGIN
    FOR i IN (
        SELECT 
            (a.val_total_pedido - a.val_desconto) AS valor_total,
            a.val_desconto,
            a.status
        FROM
            pedido a 
            JOIN item_pedido b ON a.cod_pedido = b.cod_pedido 
        WHERE
            a.cod_pedido = p_cod_pedido
    ) LOOP
        v_found := TRUE;
        IF LOWER(i.status) IN ('pendente', 'processando') THEN
            v_status_label := 'PENDENTE';
        ELSE
            v_status_label := 'ENTREGUE';
        END IF;

        dbms_output.put_line('Código do pedido: ' || p_cod_pedido);
        dbms_output.put_line('Valor total do pedido: ' || i.valor_total);
        dbms_output.put_line('Valor do desconto: ' || i.val_desconto);
        dbms_output.put_line('Status do pedido: ' || v_status_label);
        dbms_output.put_line('-----------------------------------------------');
x
    END LOOP;
 
    IF NOT v_found THEN
        raise_application_error(-20002, 'ERRO! Esse pedido não existe ou não possui itens.');
    END IF;
 
EXCEPTION

    WHEN PROGRAM_ERROR THEN
        raise_application_error(-20003, 'Erro no servidor!');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END;
 
SET SERVEROUTPUT ON;

CALL prc_relatorio_pedido(0);
 
 
-- status: pendente, processando, concluído,  

SELECT * FROM pedido a JOIN item_pedido b ON a.cod_pedido = b.cod_pedido WHERE a.cod_pedido = 130758;

SELECT DISTINCT(status) from pedido;

 