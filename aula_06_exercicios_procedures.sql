-- ex 1 | ListarPedidosCliente 
CREATE OR REPLACE PROCEDURE ListarPedidosCliente (
    p_cod_cliente NUMBER
) AS
BEGIN
FOR i IN (
 SELECT
        a.cod_pedido,
        a.dat_pedido,
        (a.val_total_pedido - a.val_desconto) "Valor Total Pedido"
    FROM
             pedido a
        INNER JOIN cliente b ON ( a.cod_cliente = b.cod_cliente )
    WHERE
        a.cod_cliente = p_cod_cliente
)LOOP
   dbms_output.put_line('Numero do pedido: ' || i.cod_pedido);
   dbms_output.put_line('Data do pedido: ' || i.dat_pedido);
   dbms_output.put_line('Valor total do pedido: ' || i."Valor Total Pedido");
   dbms_output.put_line('-----------------------------------');
    END LOOP;
END;

SET SERVEROUTPUT ON;
CALL ListarPedidosCliente(2); 

-- ex 2 | ListarItensPedido
CREATE OR REPLACE PROCEDURE ListarItensPedido (
    p_cod_pedido NUMBER
) AS 
BEGIN 
FOR i IN (
    SELECT 
        b.cod_item_pedido, 
        c.nom_produto,
        b.qtd_item
    FROM 
        pedido a
        JOIN item_pedido b ON ( a.cod_pedido = b.cod_pedido )
        JOIN produto     c ON ( b.cod_produto = c.cod_produto )
    WHERE 
        a.cod_pedido = p_cod_pedido
    ORDER BY b.cod_item_pedido
) LOOP
   dbms_output.put_line('Codigo do item : ' || i.cod_item_pedido);
   dbms_output.put_line('Nome do produto: ' || i.nom_produto);
   dbms_output.put_line('Quantidade de itens: ' || i.qtd_item);
   dbms_output.put_line('-----------------------------------');
    END LOOP;
END;

SET SERVEROUTPUT ON;
CALL ListarItensPedido(130757); 

-- ex 3 | ListarMovimentosEstoqueProduto
CREATE OR REPLACE PROCEDURE ListarMovimentosEstoqueProduto (
    p_cod_produto NUMBER
) AS 
BEGIN 
FOR i IN (
    SELECT 
        a.dat_movimento_estoque,
        a.seq_movimento_estoque,
        b.des_tipo_movimento_estoque
    FROM 
        movimento_estoque a
        JOIN tipo_movimento_estoque b ON ( a.cod_tipo_movimento_estoque = b.cod_tipo_movimento_estoque )
    WHERE 
        a.cod_produto = 1
    ORDER BY a.dat_movimento_estoque
) LOOP
   dbms_output.put_line('Codigo do produto : ' || p_cod_produto);
   dbms_output.put_line('Codigo do movimento : ' || i.seq_movimento_estoque);
   dbms_output.put_line('Data do movimento: ' || i.dat_movimento_estoque);
   dbms_output.put_line('Tipo de movimento: ' || i.des_tipo_movimento_estoque);
   dbms_output.put_line('-----------------------------------');
    END LOOP;
END;

SET SERVEROUTPUT ON;
CALL ListarMovimentosEstoqueProduto(1); 

-- ex 4 | prc_insere_produto 
CREATE OR REPLACE PROCEDURE prc_insere_produto (
    p_cod_produto NUMBER,
    p_nom_produto VARCHAR2,
    p_cod_barra NUMBER,
    p_sta_ativo VARCHAR2,
    p_dat_cadastro DATE
) AS 
BEGIN
    IF REGEXP_LIKE (p_nom_produto, '[^0-9]') AND LENGTH(p_nom_produto) > 3 THEN
    INSERT INTO produto VALUES 
    (
        p_cod_produto,
        p_nom_produto,
        p_cod_barra,
        p_sta_ativo,
        p_dat_cadastro,
        null
    );
    END IF;
    COMMIT; 
END;

SET SERVEROUTPUT ON;
CALL prc_insere_produto(52, 'Mouse', 5678905734100, 'Ativo', sysdate);

-- ex 5 | prc_insere_cliente  
CREATE OR REPLACE PROCEDURE prc_insere_cliente(
    p_cod NUMBER,
    p_nom_cliente_des_razao VARCHAR2,
    p_tipo VARCHAR2,
    p_num_cpf_cnpj VARCHAR2,
    p_dat_cadastro DATE,
    p_status VARCHAR2
) AS
BEGIN
    IF LENGTH(p_nom_cliente_des_razao) > 3 AND REGEXP_LIKE(p_nom_cliente_des_razao, '[^0-9]') THEN
        IF p_tipo = 'F' THEN 
            INSERT INTO cliente VALUES (
                p_cod,
                p_nom_cliente_des_razao,
                null,
                p_tipo,
                p_num_cpf_cnpj,
                p_dat_cadastro,
                null,
                p_status
            );
        ELSE
            INSERT INTO cliente VALUES (
                p_cod,
                p_nom_cliente_des_razao,
                p_nom_cliente_des_razao,
                p_tipo,
                p_num_cpf_cnpj,
                p_dat_cadastro,
                null,
                p_status
            );
            COMMIT;
        END IF;
    END IF;
END;

SET SERVEROUTPUT ON;
CALL prc_insere_cliente(152, 'Clínica dos Olhos', 'J', 34567892300489, SYSDATE, 'S');


SELECT * FROM cliente WHERE cod_cliente = 152;