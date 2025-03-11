SET SERVEROUTPUT ON;

-- 1. Utilizando loop, com condição de parada
DECLARE
    v_contador NUMBER(2) := 1;
BEGIN
    LOOP
        dbms_output.put_line(v_contador);
        v_contador := v_contador + 1;
        EXIT WHEN v_contador > 20;
    END LOOP;
END;

-- 2. Utilizando while, enquanto for faça 
DECLARE
    v_contador NUMBER(2) := 1;
BEGIN
    WHILE v_contador <= 20 LOOP
        dbms_output.put_line(v_contador);
        v_contador := v_contador + 1;
    END LOOP;
END;

-- 2. Utilizando for, sem precisar de váriavel
-- para v_contador in (entre) valor inicial .. (e - o range) 20 faça
BEGIN
    FOR v_contador IN 1..20 LOOP
        dbms_output.put_line(v_contador);
    END LOOP;
END;

-- 2° - de trás pra frente
BEGIN
    FOR v_contador IN REVERSE 1..20 LOOP
        dbms_output.put_line(v_contador);
    END LOOP;
END;

-- Exercício 1: montar um bloco de programação que realize o processamento de uma tabuada qualquer, por exemplo a tabuada do número 150
BEGIN
    dbms_output.put_line('Tabuada do 5: ');
    FOR v_contador IN 1..10 LOOP
        dbms_output.put_line(v_contador * 5);
    END LOOP;

END;

-- Exercício 2: Em um intervalo numérico inteiro, informar quantos números são pares e quantos são ímpares.
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

    dbms_output.put_line('Nesse intervalo têm '
                         || par
                         || ' números pares e '
                         || impar
                         || ' números impares.');

END;

-- Exercício 3: Exibir e média dos valores pares em um intervalo numérico e soma dos ímpares.

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
    dbms_output.put_line('Média dos números pares é: ' || soma_par/par);                     
    dbms_output.put_line('Soma dos números impares é: ' || soma_impar);
END;