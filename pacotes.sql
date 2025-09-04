--- Especificação do pacote
--- Aqui criamos um pacote chamado pkg_matematica com duas funções públicas: soma e multiplica.

SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE pkg_matematica AS
   FUNCTION soma(p_a NUMBER, p_b NUMBER) RETURN NUMBER;
   FUNCTION multiplica(p_a NUMBER, p_b NUMBER) RETURN NUMBER;
   FUNCTION divisao(p_a NUMBER, p_b NUMBER) RETURN NUMBER;
END pkg_matematica;
/

--- Corpo do pacote
--- Implementação das funções declaradas no spec.

CREATE OR REPLACE PACKAGE BODY pkg_matematica AS

   FUNCTION soma(p_a NUMBER, p_b NUMBER) RETURN NUMBER IS
   BEGIN
      RETURN p_a + p_b;
   END soma;

   FUNCTION multiplica(p_a NUMBER, p_b NUMBER) RETURN NUMBER IS
   BEGIN
      RETURN p_a * p_b;
   END multiplica;
   
   FUNCTION divisao(p_a NUMBER, p_b NUMBER) RETURN NUMBER IS
   BEGIN
      RETURN p_a / p_b;
   END divisao; 

END pkg_matematica;
/

--- Usando o Pacote

DECLARE
   v_resultado NUMBER;
BEGIN
   v_resultado := pkg_matematica.soma(10, 5);
   DBMS_OUTPUT.PUT_LINE('Soma: ' || v_resultado);

   v_resultado := pkg_matematica.multiplica(4, 3);
   DBMS_OUTPUT.PUT_LINE('Multiplicação: ' || v_resultado);
   
     v_resultado := pkg_matematica.divisao(10, 5);
   DBMS_OUTPUT.PUT_LINE('Multiplicação: ' || v_resultado);
END;
/
