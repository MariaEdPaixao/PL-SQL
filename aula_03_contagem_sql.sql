SELECT * FROM VENDAS;

-- CRIAR UM BLOCO PARA TRAZER A QUANTIDADE DE PEDIDOS POR PAIS

set serveroutput on;

DECLARE
    pais VARCHAR2(30) := '&digite';
    qnt_pedidos INT;
BEGIN
    SELECT
        COUNT(*)
    INTO qnt_pedidos
    FROM
        vendas
    WHERE
        country = pais;

    dbms_output.put_line('A quantidade de pedidos para esse país é: ' || qnt_pedidos);
END;

-------------------------------------------------------------------------

DECLARE
    pais VARCHAR2(30) := '&digite';
    qnt_pedidos INT;
    qnt_produtos INT;
BEGIN
    SELECT
        COUNT(1),
        SUM(QUANTITYORDERED)
    INTO qnt_pedidos, qnt_produtos
    FROM
        vendas
    WHERE
        country = pais;

    dbms_output.put_line('A quantidade de pedidos para esse país é: ' || qnt_pedidos || '. Quantidade de produtos: ' || qnt_produtos);
END;

----------------------------------------------------------------------------------------------------------
   
-- do prof -- pega a primeira coluna COUNT(1)
DECLARE 
    pedidos NUMBER;
    pais VARCHAR2(30);
BEGIN
    SELECT 
        COUNT(1),
        country
    INTO 
        pedidos,
        pais
    FROM    
        vendas
    WHERE 
    country = 'France'
    GROUP BY
        country;
    dmbs_output.put_line('A Quantidade de pedidos do pais'
                         || pais
                         || ' É '
                         || pedidos);
END;                         
                         