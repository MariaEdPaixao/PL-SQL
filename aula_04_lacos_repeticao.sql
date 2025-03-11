SET SERVEROUTPUT ON;

-- 1. Utilizando loop, com condi��o de parada
DECLARE
    v_contador NUMBER(2) := 1;
BEGIN
    LOOP
        dbms_output.put_line(v_contador);
        v_contador := v_contador + 1;
        EXIT WHEN v_contador > 20;
    END LOOP;
END;

-- 2. Utilizando while, enquanto for fa�a 
DECLARE
    v_contador NUMBER(2) := 1;
BEGIN
    WHILE v_contador <= 20 LOOP
        dbms_output.put_line(v_contador);
        v_contador := v_contador + 1;
    END LOOP;
END;

-- 2. Utilizando for, sem precisar de v�riavel
-- para v_contador in (entre) valor inicial .. (e - o range) 20 fa�a
BEGIN
    FOR v_contador IN 1..20 LOOP
        dbms_output.put_line(v_contador);
    END LOOP;
END;

-- 2� - de tr�s pra frente
BEGIN
    FOR v_contador IN REVERSE 1..20 LOOP
        dbms_output.put_line(v_contador);
    END LOOP;
END;

-- Exerc�cio 1: montar um bloco de programa��o que realize o processamento de uma tabuada qualquer, por exemplo a tabuada do n�mero 150
BEGIN
    dbms_output.put_line('Tabuada do 5: ');
    FOR v_contador IN 1..10 LOOP
        dbms_output.put_line(v_contador * 5);
    END LOOP;

END;

-- Exerc�cio 2: Em um intervalo num�rico inteiro, informar quantos n�meros s�o pares e quantos s�o �mpares.
DECLARE
    par   NUMBER(2) := 0;
    impar NUMBER(2) := 0;
BEGIN
    dbms_output.put_line('');
    FOR x IN 1..27 LOOP
        IF MOD(x, 2) = 0 THEN
            par := par + 1;
        ELSE
            impar := impar + 1;
        END IF;
    END LOOP;

    dbms_output.put_line('Nesse intervalo t�m '
                         || par
                         || ' n�meros pares e '
                         || impar
                         || ' n�meros impares.');

END;

-- Exerc�cio 3: Exibir e m�dia dos valores pares em um intervalo num�rico e soma dos �mpares.

DECLARE
    par   NUMBER := 0;
    impar NUMBER := 0;
    soma_par NUMBER := 0;
    soma_impar NUMBER := 0;
BEGIN
    dbms_output.put_line('');
    FOR x IN 1..27 LOOP
        IF MOD(x, 2) = 0 THEN
            par := par + 1;
            soma_par := soma_par + x;
        ELSE
            impar := impar + 1;
            soma_impar := soma_impar + x;
        END IF;
    END LOOP;

    dbms_output.put_line('');
    dbms_output.put_line('M�dia dos n�meros pares �: ' || soma_par/par);                     
    dbms_output.put_line('Soma dos n�meros impares �: ' || soma_impar);
END;