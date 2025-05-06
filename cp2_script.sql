SET SERVEROUTPUT ON;

-- Maria Eduarda Alves da Paixao - RM558832

-- EX 1 – fnc_valor_total_por_estado
-- historico_pedido, endereco_cliente, cidade e estado. 
CREATE OR REPLACE FUNCTION fnc_valor_total_por_estado (
    p_cod_estado NUMBER
) RETURN NUMBER IS
    valor_total NUMBER;
BEGIN
    SELECT
        ROUND(SUM(b.val_total_pedido), 2)
    INTO 
        valor_total
    FROM
             pedido a
        JOIN historico_pedido b ON ( a.cod_pedido = b.cod_pedido )
        JOIN endereco_cliente c ON ( a.cod_cliente = c.cod_cliente )
        JOIN cidade           d ON ( c.cod_cidade = d.cod_cidade )
        JOIN estado           e ON ( d.cod_estado = e.cod_estado )
    WHERE e.cod_estado = p_cod_estado 
    AND a.dat_entrega IS NOT NULL;
 
    RETURN valor_total;

END fnc_valor_total_por_estado;

-- testando ex1
SELECT
    fnc_valor_total_por_estado(3)
FROM
    dual;
    
-- testando
SELECT  ROUND(SUM(b.val_total_pedido), 2) FROM pedido a 
JOIN historico_pedido b ON (a.cod_pedido = b.cod_pedido) 
JOIN endereco_cliente c ON (a.cod_cliente = c.cod_cliente)
JOIN cidade d ON (c.cod_cidade = d.cod_cidade)
JOIN estado e ON (d.cod_estado = e.cod_estado)
WHERE e.cod_estado = 1;

-- EX 2 - fnc_qtd_itens_em_pedidos_por_produto
-- JOINs entre item_pedido, pedido e produto 
CREATE OR REPLACE FUNCTION fnc_qtd_itens_em_pedidos_por_produto (
    p_cod_produto NUMBER
) RETURN NUMBER IS
    valor_total_itens NUMBER;
BEGIN
    SELECT
        SUM(b.qtd_item)
    INTO 
        valor_total_itens
    FROM
             produto a
        JOIN item_pedido b ON ( a.cod_produto = b.cod_produto )
        JOIN pedido      c ON ( b.cod_pedido = c.cod_pedido )
    WHERE
        a.cod_produto = p_cod_produto;
 
    RETURN valor_total_itens;

END fnc_qtd_itens_em_pedidos_por_produto;

-- testando ex2
SELECT
    fnc_qtd_itens_em_pedidos_por_produto(33)
FROM
    dual;
    

-- testando
select SUM(b.qtd_item) from produto a 
JOIN item_pedido b ON (a.cod_produto = b.cod_produto)
JOIN pedido c ON (b.cod_pedido = c.cod_pedido )
WHERE a.cod_produto = 2
;

-- EX 3 - prc_relatorio_pedidos_por_cliente
CREATE OR REPLACE PROCEDURE prc_relatorio_pedidos_por_cliente AS 
    me_erro EXCEPTION;
    cancelado       VARCHAR2(30);
BEGIN
    FOR i IN (
        SELECT
            a.nom_cliente,
            d.nom_cidade,
            b.dat_cancelamento,
            COUNT(1) AS qtd_pedidos,
            ROUND(SUM(b.val_total_pedido - b.val_desconto),2) AS total_pedidos
        FROM
            cliente          a
            LEFT JOIN pedido           b ON ( a.cod_cliente = b.cod_cliente )
            JOIN endereco_cliente c ON ( a.cod_cliente = c.cod_cliente )
            JOIN cidade           d ON ( c.cod_cidade = d.cod_cidade )
        GROUP BY 
            a.nom_cliente,
            d.nom_cidade,
            b.dat_cancelamento
    ) LOOP
        IF i.dat_cancelamento IS NULL THEN
            cancelado := 'pedido não cancelado';
        ELSE 
            cancelado := 'pedido cancelado';
        END IF;
        
        IF i.nom_cidade IS NULL THEN 
            RAISE me_erro;
        END IF;
    
        dbms_output.put_line('Nome do cliente: ' || i.nom_cliente);
        dbms_output.put_line('Nome da cidade: ' || i.nom_cidade);
        dbms_output.put_line('Quantidade de pedido realizados: ' || i.qtd_pedidos);
        dbms_output.put_line('Valor total comprado: ' || i.total_pedidos);
        dbms_output.put_line('Cancelado? ' || cancelado);
        dbms_output.put_line('-----------------------------------------');
    END LOOP;

EXCEPTION
    WHEN me_erro THEN
        raise_application_error(-20002, 'Erro! Não há cidade associada com o cliente');

    WHEN program_error THEN
        raise_application_error(-20002, 'Erro no servidor!');

END;

-- testando ex3
CALL prc_relatorio_pedidos_por_cliente();


-- EX 4 - prc_movimentacao_produto_por_vendedor
CREATE OR REPLACE PROCEDURE prc_movimentacao_produto_por_vendedor AS 
    me_erro EXCEPTION;
    vendas       VARCHAR2(30);
BEGIN
    FOR i IN (
       SELECT
        a.nom_vendedor,
        COUNT(1) AS qtd_total,
        ROUND(SUM(b.val_total_pedido - b.val_desconto),2) AS total_pedidos
       FROM
        vendedor    a
        RIGHT JOIN pedido      b ON ( a.cod_vendedor = b.cod_vendedor )
        JOIN item_pedido c ON ( b.cod_pedido = c.cod_pedido )
        JOIN produto     d ON ( c.cod_produto = d.cod_produto )
        GROUP BY 
        a.nom_vendedor
    ) LOOP
        IF i.qtd_total = 0 THEN 
            vendas := 'Sem vendas registradas';
        ELSE 
            vendas := 'Vendas registradas';
        END IF;
    
        dbms_output.put_line('Nome do vendedor: ' || i.nom_vendedor);
        dbms_output.put_line('Quantidade total de vendas: ' || i.qtd_total);
        dbms_output.put_line('Valor total de vendar por produto: ' || i.total_pedidos);
        dbms_output.put_line('Vendas? ' || vendas);
        dbms_output.put_line('-----------------------------------------');
    END LOOP;

END;

-- testando ex4
CALL prc_movimentacao_produto_por_vendedor();

-- testando
select * from vendedor a 
RIGHT JOIN pedido b ON (a.cod_vendedor = b.cod_vendedor)
JOIN item_pedido c ON (b.cod_pedido = c.cod_pedido)
JOIN produto d ON (c.cod_produto = d.cod_produto);


-- EX 5 - prc_analise_vendas_por_vendedor
-- JOINS vendedor, pedido, item_pedido, produto e cliente  
CREATE OR REPLACE PROCEDURE prc_movimentacao_produto_por_vendedor(
    p_cod_vendedor NUMBER
)IS 
    me_erro EXCEPTION;
    cliente_fiel       VARCHAR2(30);
BEGIN
    FOR i IN (
       SELECT
        e.nom_cliente,
        d.nom_produto,
        COUNT(1) AS qtd_total
       FROM
        vendedor    a
        JOIN pedido      b ON ( a.cod_vendedor = b.cod_vendedor )
        JOIN item_pedido c ON ( b.cod_pedido = c.cod_pedido )
        JOIN produto     d ON ( c.cod_produto = d.cod_produto )
        JOIN cliente     e ON ( b.cod_pedido = e.cod_pedido )
        WHERE a.cod_vendedor = p_cod_vendedor
        GROUP BY 
         e.nom_cliente,
        d.nom_produto
    ) LOOP
        IF i.qtd_total > 50 THEN 
            cliente_fiel := 'CLIENTE FIEL';
        ELSE IF i.qtd_total > 11 AND i.qtd_total <50 THEN
            cliente_fiel := 'CLIENTE RECORRENTE';
        ELSE IF i.qtd_total >= 10 THEN
            cliente_fiel := 'CLIENTE OCASIONAL';
        ELSE IF i.qtd_total = 0 THEN
            cliente_fiel := 'NENHUMA COMPRA REGISTRADA';
        END IF;
    
        dbms_output.put_line('Nome do cliente: ' || i.nom_cliente);
        dbms_output.put_line('Nome do produto: ' || i.nom_produto);
        dbms_output.put_line('Quantidade total comprada: ' || i.total_pedidos);
        dbms_output.put_line('Tipo do cliente: ' || cliente_fiel);
        dbms_output.put_line('-----------------------------------------');
    END LOOP;

END;

-- testando ex5
CALL prc_movimentacao_produto_por_vendedor(2);
