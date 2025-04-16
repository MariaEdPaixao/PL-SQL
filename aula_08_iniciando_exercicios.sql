-- Maria Eduarda Alves da Paixão - RM558832

-- 1? fun?ao ? fnc_percentual_desconto
-- inner join, garantindo que vai ter dos dois lados
 
CREATE OR REPLACE FUNCTION fnc_percentual_desconto (
    f_cod_pedido NUMBER    
) RETURN NUMBER IS
    me_erro EXCEPTION;
    v_itens NUMBER;
    perc_desconto NUMBER;
BEGIN
    SELECT
        COUNT(b.cod_pedido), 
        ROUND((a.val_desconto / (a.val_total_pedido + a.val_desconto)) * 100, 2)
    INTO 
        v_itens, 
        perc_desconto
    FROM
        pedido a
        INNER JOIN item_pedido b ON ( a.cod_pedido = b.cod_pedido )
    WHERE
        a.cod_pedido = f_cod_pedido
    GROUP BY
        a.cod_pedido, a.val_total_pedido, a.val_desconto;
 
    IF v_itens = 0 THEN
        RAISE me_erro;
    END IF;
 
    RETURN perc_desconto;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        raise_application_error(-20002, 'ERRO! Esse pedido não existe');
    WHEN ZERO_DIVIDE THEN
        raise_application_error(-20003, 'ERRO! Tentativa de divisão por zero.');
    WHEN PROGRAM_ERROR THEN
        raise_application_error(-20004, 'ERRO inesperado no programa.');
    WHEN me_erro THEN
        raise_application_error(-20005, 'ERRO! Pedido sem itens.');
    WHEN OTHERS THEN
        raise_application_error(-20006, 'Erro desconhecido: ' || SQLERRM);
END fnc_percentual_desconto;
 
 
-- testando a fun??o
SELECT fnc_percentual_desconto(130777) FROM DUAL;

-- 2° função - fnc_media_itens_por_pedido
CREATE OR REPLACE FUNCTION fnc_media_itens_por_pedido RETURN NUMBER IS 
    quantidade_itens NUMBER;
    v_total_itens NUMBER;
    v_total_pedidos NUMBER;
    me_erro EXCEPTION;
BEGIN
    -- Conta total de itens e pedidos válidos
    SELECT 
        SUM(b.qtd_item),
        COUNT(DISTINCT a.cod_pedido)
    INTO 
        v_total_itens,
        v_total_pedidos
    FROM 
        pedido a
        INNER JOIN item_pedido b ON a.cod_pedido = b.cod_pedido
        INNER JOIN historico_pedido c ON a.cod_pedido = c.cod_pedido;

    -- Valida divisão por zero
    IF v_total_pedidos = 0 THEN
        RAISE me_erro;
    END IF;

    -- Calcula a média
    quantidade_itens := ROUND(v_total_itens / v_total_pedidos, 2);

    RETURN quantidade_itens;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        raise_application_error(-20002, 'ERRO! Nenhum pedido encontrado');
    WHEN ZERO_DIVIDE THEN
        raise_application_error(-20003, 'ERRO! Tentativa de divisão por zero.');
    WHEN PROGRAM_ERROR THEN
        raise_application_error(-20004, 'ERRO inesperado no programa.');
    WHEN me_erro THEN
        raise_application_error(-20003, 'ERRO! Tentativa de divisão por zero.');
    WHEN OTHERS THEN
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END fnc_media_itens_por_pedido;    

SELECT fnc_media_itens_por_pedido FROM DUAL;

-- 3° procedure - prc_relatorio_estoque_produto
CREATE OR REPLACE PROCEDURE prc_relatorio_estoque_produto (
    p_cod_produto NUMBER
) IS
    total_unidades NUMBER;
    data_max_movimentacao DATE;
    me_erro  EXCEPTION;
BEGIN
    SELECT 
        SUM(a.qtd_movimentacao_estoque),
        MAX(a.dat_movimento_estoque)
    INTO 
        total_unidades,
        data_max_movimentacao
    FROM 
        movimento_estoque a
        LEFT JOIN produto_composto b ON a.cod_produto = b.cod_produto
    WHERE 
        a.cod_produto = p_cod_produto;
 
    IF total_unidades IS NULL AND data_max_movimentacao IS NULL THEN
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
        raise_application_error(-20005, 'Erro desconhecido: ' || SQLERRM);
END;

CALL prc_relatorio_estoque_produto(25);