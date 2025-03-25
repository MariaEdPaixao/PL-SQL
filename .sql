-- CHAMANDO PROCEDURE
CALL prd_insert_pais(); --java, python 
EXEC prd_insert_pais(); --java
EXECUTE prd_insert_pais(); -- python, .NET

-- java, .net
BEGIN 
    prd_insert_pais();
END;

CALL prd_insert_pais(555, 'JAMAICA'); 
CALL prd_delete_pais(555);
CALL prd_update_pais(555, 'Jamaica'); 

SET SERVEROUTPUT ON;
CALL prd_ultimo_pedido_cliente(1);