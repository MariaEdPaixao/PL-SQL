SET SERVEROUTPUT ON;

-- 01 

DECLARE
    id_produto         NUMBER := 16;
    total_movimentacao NUMBER := 0;
BEGIN
    SELECT
        SUM(qtd_movimentacao_estoque)
    INTO total_movimentacao
    FROM
        movimento_estoque
    WHERE
        cod_produto = id_produto;

    dbms_output.put_line('ID do produto: '
                         || id_produto
                         || ' | Total de movimenta??o: '
                         || total_movimentacao);
END;

-- 2
DECLARE
    id_cliente         NUMBER := '&id';
    soma_valores       NUMBER := 0;
    quantidade_pedidos NUMBER := 0;
BEGIN
    SELECT
        COUNT(1)
    INTO quantidade_pedidos
    FROM
        pedido
    WHERE
        cod_cliente = id_cliente;

    FOR i IN (
        SELECT
            *
        FROM
            pedido
        WHERE
            cod_cliente = id_cliente
    ) LOOP
        soma_valores := soma_valores + i.val_total_pedido;
    END LOOP;

    dbms_output.put_line('ID do cliente: '
                         || id_cliente
                         || ' | Quantidade de pedidos: '
                         || quantidade_pedidos
                         || ' | M?dia dos pedidos: '
                         || soma_valores / quantidade_pedidos);

END;

-- 3
BEGIN
    dbms_output.put_line('--- Produtos compostos ativos ---');
    dbms_output.put_line(' ');
    FOR i IN (
        SELECT
            *
        FROM
            produto_composto
        WHERE
            sta_ativo = 'S'
    ) LOOP
        dbms_output.put_line('C?d do produto: '
                             || i.cod_produto
                             || ' | Quantidade de produtos: '
                             || i.qtd_produto
                             || ' | C?d produto relacionado: '
                             || i.cod_produto_relacionado);
    END LOOP;

END;

-- 4 
DECLARE
    total_movimentacao_saida NUMBER := 0;
    total_movimentacao_entrada NUMBER := 0;
    id_produto NUMBER := '&produto';
BEGIN
    -- produtos de sa?da 
    SELECT SUM(qtd_movimentacao_estoque) INTO total_movimentacao_saida
    FROM 
    movimento_estoque me
    INNER JOIN tipo_movimento_estoque tp ON (me.cod_tipo_movimento_estoque = tp.cod_tipo_movimento_estoque)
    WHERE tp.sta_saida_entrada = 'S' AND me.cod_produto = id_produto;
    
    -- produtos de entrada
    SELECT SUM(qtd_movimentacao_estoque) INTO total_movimentacao_entrada
    FROM 
    movimento_estoque me
    INNER JOIN tipo_movimento_estoque tp ON (me.cod_tipo_movimento_estoque = tp.cod_tipo_movimento_estoque)
    WHERE tp.sta_saida_entrada = 'E' AND me.cod_produto = id_produto;
    
    dbms_output.put_line('C?d do produto: '
                             || id_produto
                             || ' | Total de movimenta??o de sa?da: '
                             || total_movimentacao_saida
                             || ' | Total de movimenta??o de entrada: '
                             || total_movimentacao_entrada);
END;

-- 5

BEGIN
    FOR i IN (
        SELECT
            p.nom_produto AS nome_produto,
            SUM(e.qtd_produto) AS quantidade_do_estoque
        FROM
            produto_composto pc
            LEFT JOIN produto          p ON  pc.cod_produto = p.cod_produto 
            LEFT JOIN estoque_produto  e ON  pc.cod_produto = e.cod_produto 
        GROUP BY
            p.nom_produto,
            pc.cod_produto
    ) LOOP
    
    dbms_output.put_line('Nome do produto: '
                             || i.nome_produto);
                             
    IF i.quantidade_do_estoque> 0 THEN
      dbms_output.put_line('Total de quantidade no estoque: '
                             || i.quantidade_do_estoque);
    dbms_output.put_line(' ');
    ELSE
      dbms_output.put_line('Nenhum registro foi encontrado');
    END IF;
    END LOOP;

END;

SET SERVEROUTPUT ON;

-- 6
BEGIN
    FOR i IN (
        SELECT
            p.cod_pedido       AS codigo_pedido,
            p.val_total_pedido AS val_total,
            c.cod_cliente      AS codigo_cliente,
            c.nom_cliente      AS nome_cliente
        FROM 
            cliente c
        RIGHT JOIN pedido p  ON p.cod_cliente = c.cod_cliente
        WHERE
                p.status = 'concluído'
            AND ROWNUM <= 50
    )LOOP
     dbms_output.put_line('Cód pedido: '
                             || i.codigo_pedido
                             || ' | Valor total do pedido: '
                             || i.val_total);
        IF i.nome_cliente IS NOT NULL THEN
            dbms_output.put_line('Nome do cliente: '
                             || i.nome_cliente
                             || ' | Cód do cliente: '
                             || i.codigo_cliente);
             dbms_output.put_line('');
            
        END IF;
    END LOOP;
END;

-- 7 //cada grupo corresponde a um cliente único, por isso group by com cliente 
-- c.nom_cliente deve estar no GROUP BY porque é um dado textual e não pode ser agregado (não pode ser somado ou contado diretamente).
-- Se incluirmos p.cod_pedido no GROUP BY, cada pedido se tornaria um grupo separado, impedindo o cálculo correto da média por cliente. 
-- O GROUP BY precisa incluir todos os campos não agregados da SELECT. 
DECLARE
    id_cliente NUMBER := '&id';
BEGIN
    FOR i IN(
        SELECT 
            TRUNC(AVG(p.val_total_pedido),2) AS media_pedidos,
            c.cod_cliente      AS codigo_cliente,
            c.nom_cliente      AS nome_cliente
        FROM 
            pedido p
        INNER JOIN  
            cliente c ON (p.cod_cliente = c.cod_cliente)
        WHERE
            p.cod_cliente = id_cliente
        GROUP BY
        c.cod_cliente, c.nom_cliente
    )LOOP
         dbms_output.put_line('Nome do cliente: '
                                 || i.nome_cliente
                                 || ' | Cód do cliente: '
                                 || i.codigo_cliente);
         dbms_output.put_line('Média de valores totais dos pedidos: '
                                 || i.media_pedidos);
         dbms_output.put_line('');
     END LOOP;
END;