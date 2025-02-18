-- PL/SQL - Bloco anonimo: estrutura de c�digo que n�o salvo em nenhum lugar, fica na IDE

 -- s� para mostrar o valor da v�riavel
SET SERVEROUTPUT ON;

DECLARE
    idade NUMBER;
    nome  VARCHAR2(30) := 'VERGS';
    ende VARCHAR2(50) := '&ENDERECO';
BEGIN
    idade := 39; -- atribuindo valor para v�riavel
    dbms_output.put_line('A idade informada � : ' || idade);
    dbms_output.put_line('O nome informado � : ' || nome);
    dbms_output.put_line('O endere�o informado � : ' || ende);
END;

-- 1. Criar um bloco PL-SQL para calcular o valor do novo sal�rio m�nimo que dever� ser de 25% em cima do atual, que � de R$??

DECLARE
    salario_novo NUMBER;
    salario_atual NUMBER := 1518;
BEGIN
    salario_novo := salario_atual+(salario_atual*0.25);
    dbms_output.put_line('O valor do novo sal�rio m�nimo � : ' || salario_novo);
END;

---

DECLARE
    salario_atual FLOAT := 1518;
BEGIN
    dbms_output.put_line('O valor do novo sal�rio m�nimo � : ' || salario_atual*1.25);
END;
    
-- 2. Criar um bloco PL-SLQ para calcular o valor em REAIS de 45 d�lares, sendo que o valor do c�mbio a ser considerado � de R$??

DECLARE
    v_dolar FLOAT := 45;
BEGIN
    dbms_output.put_line('O valor em dolares de : ' || v_dolar || '� de '|| v_dolar*5.70 || ' reais');
END;

-- 3. Criar um bloco PL-SLQ para calcular o valor das parcelas de uma compra de um carro, nas seguintes condi��es:
/* observa��es:
    1. parcelas para aquisi��o em 10 pagamentos.
    2. o valor da compra dever� ser informado em tempo de execu��o
    3. o valor total do juros � de 3% e dever� ser aplicado sobre o motante financiado
    4. no final informar o valor de cada parcela
    
    obs: O montante � calculado pela soma do capital com os juros (M = C + J)
*/

DECLARE
    v_carro FLOAT := '&CARRO';
    parcelas NUMBER := '&PARCELAS';
    juros NUMBER := 1.03;
BEGIN
    dbms_output.put_line('O valor das parcelas : R$' || ((v_carro*juros)/parcelas));
END;

-- resolu��o do professor
DECLARE 
    CARRO NUMBER:= &VALOR;
BEGIN
    dbms_output.put_line('VALOR DO CARRO A VISTA : R$' || CARRO);
    dbms_output.put_line('VALOR DE CADA PARCELA : R$' || (CARRO*1.03)/10);
    dbms_output.put_line('VALOR DO CARRO FINANCIADO : R$' || CARRO*1.03);
END;
    

