-- hardcode insert
INSERT INTO pais VALUES (
    18,
    'Tailândia'
);

COMMIT;

SELECT
    *
FROM
    pais;

SET SERVEROUTPUT ON;

-- Transforme esse insert em um bloco anonimo utilizando variáveis
DECLARE
    cod_pais  NUMBER := &codigo;
    nome_pais VARCHAR2(30) := '&nome';
BEGIN
    INSERT INTO pais VALUES (
        cod_pais,
        nome_pais
    );

    COMMIT;
END;

-- procedure
-- criando um objeto do tipo procedure
CREATE OR REPLACE PROCEDURE PRD_INSERT_PAIS(
 p_cod  NUMBER,
 p_nome VARCHAR2

) AS 
BEGIN 
    INSERT INTO pais VALUES(
        p_cod,
        p_nome
    );
    COMMIT;
END;

-- replace - atualizar ou substituir 
-- procedure de delete no país 
CREATE OR REPLACE PROCEDURE PRD_DELETE_PAIS(
    p_cod NUMBER
) AS

BEGIN 
    DELETE FROM PAIS WHERE cod_pais = p_cod;
    COMMIT;
END;

-- procedure de update no país
CREATE OR REPLACE PROCEDURE PRD_UPDATE_PAIS(
    p_cod NUMBER,
    p_nome VARCHAR2
) AS
BEGIN
    UPDATE pais SET nom_pais = p_nome WHERE cod_pais = p_cod;
    COMMIT;
END;

select * from cliente;

-- CRIE UMA PROCEDURE QUE VOCÊ INFORME O CÓDIGO DO CLIENTE E ELA RETORNE AS SEGUINTES INFORMAÇÕES
-- NOME DO CLIENTE
-- COD DO PRODUTO 
-- NOME DO PRODUTO
-- TOTAL POR PEDIDOS
SELECT * FROM pedido;
SELECT * FROM item_pedido;
SELECT * FROM produto;
SELECT * FROM cliente;

SELECT
    b.nom_cliente,
    a.cod_pedido,
    c.cod_produto,
    d.nom_produto,
    SUM(a.val_total_pedido) "Total Pedido"
FROM
         pedido a
    INNER JOIN cliente     b ON ( a.cod_cliente = b.cod_cliente )
    JOIN item_pedido c ON ( a.cod_pedido = c.cod_pedido )
    JOIN produto     d ON ( c.cod_produto = d.cod_produto )
    WHERE a.cod_pedido = 130501
GROUP BY 
    b.nom_cliente,
    a.cod_pedido,
    c.cod_produto,
    d.nom_produto;

-- cliente, pedido, valor total do pedido e o último pedido
CREATE OR REPLACE PROCEDURE prd_ultimo_pedido_cliente (
    p_cod_cliente NUMBER
) AS
BEGIN
FOR i IN (
 SELECT
        b.nom_cliente,
        
        a.cod_pedido,
        c.cod_produto,
        d.nom_produto,
        SUM(a.val_total_pedido) "Total Pedido"
    FROM
             pedido a
        INNER JOIN cliente     b ON ( a.cod_cliente = b.cod_cliente )
        JOIN item_pedido c ON ( a.cod_pedido = c.cod_pedido )
        JOIN produto     d ON ( c.cod_produto = d.cod_produto )
    WHERE
        a.cod_cliente = p_cod_cliente
    GROUP BY
        b.nom_cliente,
        a.cod_pedido,
        c.cod_produto,
        d.nom_produto
)LOOP
   dbms_output.put_line('Nome do cliente: ' || i.nom_cliente);
   dbms_output.put_line('Código do produto: ' || i.cod_produto);
   dbms_output.put_line('Nome do produto: ' || i.nom_produto);
   dbms_output.put_line('Total por pedido: ' || i."Total Pedido");
   dbms_output.put_line('');
    END LOOP;
END;

    
  SELECT
        b.nom_cliente,
        a.cod_pedido,
        c.cod_produto,
        d.nom_produto,
        SUM(a.val_total_pedido) "Total Pedido"
    FROM
             pedido a
        INNER JOIN cliente     b ON ( a.cod_cliente = b.cod_cliente )
        JOIN item_pedido c ON ( a.cod_pedido = c.cod_pedido )
        JOIN produto     d ON ( c.cod_produto = d.cod_produto )
    WHERE
        b.cod_cliente = 1
    GROUP BY
        b.nom_cliente,
        a.cod_pedido,
        c.cod_produto,
        d.nom_produto;
