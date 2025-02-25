-- só para mostrar na tela
set serveroutput on;

DECLARE
    genero CHAR(1) := '&digite';
BEGIN
    IF upper(genero) = 'M' THEN
        dbms_output.put_line('O genêro informado é Masculino');
    ELSIF upper(genero) = 'F' THEN
        dbms_output.put_line('O genêro informado é Feminino');
    ELSE
        dbms_output.put_line('Outros');
    END IF;
END;

-- ** Exercícios **

-- 1. Criar um bloco anônimo para informar se o número informado é par ou ímpar
DECLARE
    numero INT := '&digite';
BEGIN
    IF MOD(numero, 2) = 0 THEN
        dbms_output.put_line('O número é par');
    ELSE
        dbms_output.put_line('O número é ímpar');
    END IF;
END;

----------------------------------------------------------------------------------------------------------
 
-- 2. Criar um bloco anônimo para informar o usuário se a nota está acima da média, na média ou reprovado.
 -- ACIMA DE 8 E MENOR QUE 10 = NOTA ACIMA DA MÉDIA
 -- ENTRE 6 E 7 NA MÉDIA
 -- MENOR QUE 6 REPROVADO
-- ou : NOTA BETWEEN 6 AND 7 THEN

DECLARE
    nota FLOAT := '&digite';
BEGIN
    IF
        nota >= 8
        AND nota <= 10
    THEN
        dbms_output.put_line('NOTA ACIMA DA MÉDIA');
    ELSIF
        nota > 6
        AND nota < 7
    THEN
        dbms_output.put_line('NA MÉDIA');
    ELSE
        dbms_output.put_line('REPROVADO');
    END IF;
END;

-----------------------------
-- Tabela aluno | PL-SQL com SQL

CREATE TABLE tbl_aluno (
    ra   CHAR(9),
    nome VARCHAR2(50),
    CONSTRAINT aluno_pk PRIMARY KEY ( ra )
);

INSERT INTO tbl_aluno (
    ra,
    nome
) VALUES (
    '111222333',
    'Antonio Alves'
);

INSERT INTO tbl_aluno (
    ra,
    nome
) VALUES (
    '222333444',
    'Beatriz Bernandes'
);

INSERT INTO tbl_aluno (
    ra,
    nome
) VALUES (
    '333444555',
    'Cláudio Cardoso'
);

-- Buscando dados na tabela e adicionando no usuário
DECLARE
    v_ra   CHAR(9) := '333444555';
    v_nome VARCHAR2(50);
BEGIN 
    SELECT nome INTO V_NOME FROM tbl_aluno WHERE ra = v_ra;
    DBMS_OUTPUT.PUT_LINE(
        'O nome do aluno é ' || v_nome);
END;

-- Inserindo dados na tabela e adicionando no usuário da tabela
DECLARE
    v_ra   CHAR(9) := '444555666';
    v_nome VARCHAR2(50) := 'Daniela Dornoles';
BEGIN
    INSERT INTO tbl_aluno (
        ra,
        nome
    ) VALUES (
        v_ra,
        v_nome
    );
END;

SELECT * FROM tbl_aluno;

-- Atualizando um registro no banco a partir de uma variável
DECLARE
    v_ra CHAR(9) := '111222333';
    v_nome VARCHAR2(50) := 'Antonio Rodrigues';
BEGIN 
    UPDATE tbl_aluno SET NOME = v_nome WHERE ra = v_ra;
END;

-- Deletando valores do banco através de uma variável 
DECLARE
    v_ra CHAR(9) := '444555666';
BEGIN
    DELETE FROM tbl_aluno WHERE RA = v_ra;
END;