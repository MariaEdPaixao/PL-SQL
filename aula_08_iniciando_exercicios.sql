-- Maria Eduarda Alves da Paixão - RM558832

-- 1° funçao – fnc_percentual_desconto
-- inner join, garantindo que vai ter dos dois lados

CREATE OR REPLACE FUNCTION fnc_percentual_desconto (
    f_cod_pedido NUMBER    
) RETURN NUMBER IS
    perc_desconto NUMBER;
BEGIN
    
    SELECT
        ( SUM(val_desconto_item) ) / 100 INTO perc_desconto
    FROM
        pedido a
        INNER JOIN item_pedido b ON ( a.cod_pedido = b.cod_pedido )
    WHERE
        a.cod_pedido = f_cod_pedido;

    RETURN perc_desconto;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        raise_application_error(-20002, 'ERRO! Esse pedido não existe');
    WHEN ZERO_DIVIDE THEN
        raise_application_error(-20003, 'ERRO! Tentativa de divisão por zero.');
    WHEN PROGRAM_ERROR THEN
        raise_application_error(-20004, 'ERRO!');
        

END fnc_percentual_desconto;

-- testando a função
SELECT fnc_percentual_desconto(13066) FROM DUAL;

-- 2° função - fnc_media_itens_por_pedido

CREATE OR REPLACE FUNCTION fnc_media_itens_por_pedido (
    f_cod_pedido NUMBER    
) RETURN NUMBER IS
    quantidade_itens NUMBER;
BEGIN
    FOR i in (
    SELECT
        SUM(1) "quantidade itens"
    FROM
        pedido a
        INNER JOIN item_pedido b ON ( a.cod_pedido = b.cod_pedido )
        INNER JOIN historico_pedido c ON (a.cod_pedido = c.cod_pedido)
    ) LOOP
        quantidade_itens := i."quantidade itens";
        RETURN quantidade_itens;
    END LOOP;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        raise_application_error(-20002, 'ERRO! Esse pedido não existe');
    WHEN ZERO_DIVIDE THEN
        raise_application_error(-20003, 'ERRO! Tentativa de divisão por zero.');
    WHEN PROGRAM_ERROR THEN
        raise_application_error(-20004, 'ERRO!');

END fnc_media_itens_por_pedido;      

SELECT fnc_media_itens_por_pedido(1) FROM DUAL;


 SELECT
            a.cod_pedido,
            a.val_desconto,
            a.val_total_pedido
    FROM
        pedido a
        INNER JOIN item_pedido b ON ( a.cod_pedido = b.cod_pedido )
        INNER JOIN historico_pedido c ON (a.cod_pedido = c.cod_pedido)
        
        ;
        
        
SELECT
( SUM(val_desconto_item) ) / 100    FROM
        pedido a
        INNER JOIN item_pedido b ON ( a.cod_pedido = b.cod_pedido )
    WHERE
        a.cod_pedido = 130666;