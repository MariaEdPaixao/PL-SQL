CREATE OR REPLACE FUNCTION calcx_fgts (
    valor NUMBER
) RETURN NUMBER IS
BEGIN
    RETURN valor * 0.08;
END calcx_fgts;

-- tabela temporária
SELECT
    calcx_fgts(1000)
FROM
    dual;

CREATE OR REPLACE PROCEDURE prx_fgts AS
    v_valor NUMBER;
BEGIN
    v_valor := calcx_fgts(150000);
    dbms_output.put_line('O valor do FGTS É: ' || v_valor);
END;

SET SERVEROUTPUT ON;
CALL prx_fgts(100);

CREATE OR REPLACE FUNCTION calcx_fgts_ex (
    valor NUMBER    
) RETURN NUMBER IS
    me_erro EXCEPTION;
    v_valor NUMBER;
BEGIN
    v_valor := valor * 0.08;
    IF v_valor < 80 THEN
        RAISE me_erro; -- raise mostra a exceção
    END IF;
    RETURN V_VALOR;
EXCEPTION
    WHEN me_erro THEN
        raise_application_error(-20001, 'FGTS NÃO PODE SER MENOR QUE 80 REAIS');
END calcx_fgts_ex;

SELECT calcx_fgts_ex(100) FROM DUAL;


-- Exercícios 
-- 1
CREATE OR REPLACE PROCEDURE prc_insere_produto_ex(
    p_cod NUMBER,
    p_nome VARCHAR2,
    p_cod_barra NUMBER,
    p_status VARCHAR2,
    p_dat_cadastro DATE
) AS
    me_erro EXCEPTION;
BEGIN
    IF LENGTH(p_nome) < 3 OR REGEXP_LIKE(p_nome, '^[0-9]') THEN
        RAISE me_erro;
    END IF;
    INSERT INTO produto VALUES (
        p_cod,
        p_nome,
        p_cod_barra,
        p_status,
        p_dat_cadastro,
        null
    );
EXCEPTION
    WHEN me_erro THEN 
        raise_application_error(-20045, 'Nome inválido!');
    COMMIT;
END;

SET SERVEROUTPUT ON;
CALL prc_insere_produto_ex(61, 'Mouse Gamer', 5678905734100, 'Ativo', sysdate);
SELECT * FROM PRODUTO;

-- 2
CREATE OR REPLACE PROCEDURE prc_insere_cliente_ex(
    p_cod NUMBER,
    p_nom_cliente_des_razao VARCHAR2,
    p_tipo VARCHAR2,
    p_num_cpf_cnpj VARCHAR2,
    p_dat_cadastro DATE,
    p_status VARCHAR2
) AS
    me_erro EXCEPTION;
BEGIN
    IF LENGTH(p_nom_cliente_des_razao) < 3 OR REGEXP_LIKE(p_nom_cliente_des_razao, '^[0-9]') THEN
        RAISE me_erro;
    END IF;
    
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
EXCEPTION
    WHEN me_erro THEN 
        raise_application_error(-20045, 'Nome inválido: maior que 3 caracteres e não deve ter números!');
COMMIT;
END;

SET SERVEROUTPUT ON;
CALL prc_insere_cliente_ex(160, 'Maria Eduarda', 'F', 34567892300489, SYSDATE, 'S');
SELECT * FROM cliente;

-- 3 
CREATE OR REPLACE FUNCTION fun_valida_nome (
    nome VARCHAR2    
) RETURN VARCHAR2 IS
    me_erro EXCEPTION;
BEGIN
     IF LENGTH(nome) < 3 OR REGEXP_LIKE(nome, '\d') THEN
        RAISE me_erro;
    END IF;
    RETURN nome;
EXCEPTION
    WHEN me_erro THEN
        raise_application_error(-20045, 'Nome inválido: maior que 3 caracteres e não deve ter números!');
END fun_valida_nome;

SELECT fun_valida_nome('Ma9') FROM DUAL;

-- 4

-- 1
CREATE OR REPLACE PROCEDURE prc_insere_produto_ex_func(
    p_cod NUMBER,
    p_nome VARCHAR2,
    p_cod_barra NUMBER,
    p_status VARCHAR2,
    p_dat_cadastro DATE
) AS
    me_erro EXCEPTION;
BEGIN
    INSERT INTO produto VALUES (
        p_cod,
        fun_valida_nome(p_nome),
        p_cod_barra,
        p_status,
        p_dat_cadastro,
        null
    );
END;

CALL prc_insere_produto_ex_func(62, 'Teclado Gamer', 5678905734122, 'Ativo', sysdate);

-- 2 
CREATE OR REPLACE PROCEDURE prc_insere_cliente_ex_func(
    p_cod NUMBER,
    p_nom_cliente_des_razao VARCHAR2,
    p_tipo VARCHAR2,
    p_num_cpf_cnpj VARCHAR2,
    p_dat_cadastro DATE,
    p_status VARCHAR2
) AS
    me_erro EXCEPTION;
BEGIN
    IF p_tipo = 'F' THEN 
        INSERT INTO cliente VALUES (
            p_cod,
            fun_valida_nome(p_nom_cliente_des_razao),
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
            fun_valida_nome(p_nom_cliente_des_razao),
            fun_valida_nome(p_nom_cliente_des_razao),
            p_tipo,
            p_num_cpf_cnpj,
            p_dat_cadastro,
            null,
            p_status
        );
        COMMIT;
    END IF;
END;

CALL prc_insere_cliente_ex_func(160, 'Maria Eduarda', 'F', 34567892300489, SYSDATE, 'S');

--5
CREATE OR REPLACE PROCEDURE prc_insere_produto_ex(
    p_cod NUMBER,
    p_nome VARCHAR2,
    p_cod_barra NUMBER,
    p_status VARCHAR2,
    p_dat_cadastro DATE,
    p_retorno VARCHAR2
) AS
    me_erro EXCEPTION;
BEGIN
    IF LENGTH(p_nome) < 3 OR REGEXP_LIKE(p_nome, '^[0-9]') THEN
        RAISE me_erro;
    END IF;
    INSERT INTO produto VALUES (
        p_cod,
        p_nome,
        p_cod_barra,
        p_status,
        p_dat_cadastro,
        null
    );
EXCEPTION
    WHEN me_erro THEN 
        raise_application_error(-20045, 'Nome inválido!');
    COMMIT;
END;