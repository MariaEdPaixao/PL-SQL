-- PROCEDURES

/*
1. Crie uma procedure inserir_cliente(p_nome, p_data_nasc, p_email) que insira um novo 
cliente.
*/
CREATE OR REPLACE PROCEDURE inserir_cliente (
    p_nome  VARCHAR2,
    p_data  DATE,
    p_email VARCHAR2
) AS
BEGIN
    INSERT INTO clientes (
        nome,
        data_nascimento,
        email
    ) VALUES (
        p_nome,
        p_data,
        p_email
    );

    COMMIT;
END;

-- testando procedure
CALL inserir_cliente('Maria da Paixao', TO_DATE('2005-07-08', 'YYYY-MM-DD'), 'maria.paixao@email.com');

SELECT
    *
FROM
    clientes;

/*
2. Crie uma procedure inserir_produto(p_nome, p_preco, p_estoque) que adicione um 
produto.
*/

CREATE OR REPLACE PROCEDURE inserir_produto (
    p_nome    VARCHAR2,
    p_preco   NUMBER,
    p_estoque NUMBER
) AS
BEGIN
    INSERT INTO produtos (
        nome,
        preco,
        estoque
    ) VALUES (
        p_nome,
        p_preco,
        p_estoque
    );

    COMMIT;
END;

--testando procedure
CALL inserir_produto('Teclado Gamer', 199, 50);

SELECT
    *
FROM
    produtos;

/*
3. Crie uma procedure novo_pedido(p_id_cliente) que insira um pedido em aberto para um 
cliente. 
*/

CREATE OR REPLACE PROCEDURE novo_pedido (
    p_id_cliente NUMBER
) AS
BEGIN
    INSERT INTO pedidos ( id_cliente ) VALUES ( p_id_cliente );

    COMMIT;
END;

-- testando procedure

CALL novo_pedido(4)

SELECT
    *
FROM
    pedidos;

-- FUNÇÕES

/*
4. Crie uma function calcular_idade (p_id_cliente) que retorne a idade de um cliente.
*/

CREATE OR REPLACE FUNCTION calcular_idade (
    p_id_cliente NUMBER
) RETURN NUMBER IS
    v_idade NUMBER;
BEGIN
    SELECT
        trunc(months_between(sysdate, data_nascimento) / 12)
    INTO v_idade
    FROM
        clientes
    WHERE
        id_cliente = p_id_cliente;

    RETURN v_idade;
END calcular_idade;

-- testar a função
SELECT
    calcular_idade(1) AS idade
FROM
    dual;

/*
5. Crie uma function total_pedido (p_id_pedido) que calcule o valor total do pedido 
multiplicando preço × quantidade. 
*/
SELECT
    *
FROM
    pedidos;

SELECT
    *
FROM
    itens_pedido;

SELECT
    *
FROM
    produtos;

CREATE OR REPLACE FUNCTION total_pedido (
    p_id_pedido NUMBER
) RETURN NUMBER IS
    v_total NUMBER := 0;
BEGIN
    FOR i IN (
        SELECT
            pr.preco * ip.quantidade AS total
        FROM
                 pedidos p
            INNER JOIN itens_pedido ip ON ip.id_pedido = p.id_pedido
            INNER JOIN produtos     pr ON pr.id_produto = ip.id_produto
        WHERE
            p.id_pedido = p_id_pedido
    ) LOOP
        v_total := v_total + i.total;
    END LOOP;

    RETURN v_total;
END total_pedido;

-- testando função

SELECT
    total_pedido(1) AS valor_total
FROM
    dual;

SELECT
    pr.preco * ip.quantidade AS total
FROM
         pedidos p
    INNER JOIN itens_pedido ip ON ip.id_pedido = p.id_pedido
    INNER JOIN produtos     pr ON pr.id_produto = ip.id_produto
WHERE
    p.id_pedido = 1;

/*
6. Crie uma function estoque_disponivel (p_id_produto) que retorne a quantidade em 
estoque de um produto. 
*/

CREATE OR REPLACE FUNCTION estoque_disponivel (
    p_id_produto NUMBER
) RETURN NUMBER IS
    v_estoque NUMBER := 0;
BEGIN
    SELECT
        estoque
    INTO v_estoque
    FROM
        produtos
    WHERE
        id_produto = p_id_produto;

    RETURN v_estoque;
END estoque_disponivel;

SELECT
    *
FROM
    produtos;

-- testando função

SELECT
    estoque_disponivel(4) AS valor_total
FROM
    dual;

-- TRIGGERS

/*
tipos de trigger:
 before - executa antes da operação no banco --> usado para validar ou ajustar valores
 after - executa após a operação no banco --> usado para registrar logs e auditorias
 instead of - substitui a operação em visões
 row level - executa para cada linha
 statement level - executa uma vez por comando
*/

/*
Notas importantes sobre trigger:
:NEW -> acessa os novos valores do registro
:OLD -> acessa os valores antigos do registro
FOR EACH ROW -> faz a trigger disparar para cada linha afetada
RAISE_APPLICATION_ERROR -> bloqueia a operação com uma mensagem personalizada
*/


/*
7. Crie uma trigger trg_preco_produto que impeça a inserção de produtos com preço 
negativo. 

observações:
- deve ser antes da inserção de um novo produto
- condição: se o preço for negativo, a trigger vai gerar um erro, impedindo a inserção
*/

CREATE OR REPLACE TRIGGER trg_preco_produto BEFORE
    INSERT ON produtos -- antes de inserir em produtos
    FOR EACH ROW -- fazer a trigger disparar para tudo que foi afetado
BEGIN
    -- VERIFICA SE ESSE NOVO VALOR QUE TA TENTANDO SER INSERIDO É POSITIVO
    IF :new.preco < 0 THEN
        -- GERA UM ERRO CASO ESSE NOVO VALOR SEJA NEGATIVO
        raise_application_error(-20001, 'O preço do produto não pode ser negativo!');
    END IF;
END trg_preco_produto;

-- esse insert não irá chamar o erro, pois o valor nao é negativo, entao vai inserir
INSERT INTO produtos (
    nome,
    preco,
    estoque
) VALUES (
    'Monitor Samsung',
    499,
    3
);

-- esse insert chama o erro, pois o valor é negativo 
INSERT INTO produtos (
    nome,
    preco,
    estoque
) VALUES (
    'Celular',
    - 1000,
    3
);

SELECT
    *
FROM
    produtos;

/*
8. Crie uma trigger trg_atualizar_estoque que, após a inserção de um item em 
ITENS_PEDIDO, reduza automaticamente o estoque do produto.

observações:
- depois da inserção
- diminuir o valor do estoque 
*/
SELECT
    *
FROM
    itens_pedido;

SELECT
    *
FROM
    produtos;

CREATE OR REPLACE TRIGGER trg_atualizar_estoque AFTER
    INSERT ON itens_pedido
    FOR EACH ROW
DECLARE
    v_quantidade_retirar NUMBER;
    v_estoque_atual      NUMBER;
BEGIN
    -- Pegando a quantidade inserida na tabela itens_pedido 
    -- | não precisa fazer select porque ja estou no insert em si, entao ja tenho os dados, basta chama-los com :NEW
    v_quantidade_retirar := :new.quantidade;
    
    -- Pegando o estoque atual do produto relacionado ao item inserido
    SELECT
        estoque
    INTO v_estoque_atual
    FROM
        produtos
    WHERE
        id_produto = :new.id_produto;
    
    -- Atualizando o estoque do produto
    UPDATE produtos
    SET
        estoque = v_estoque_atual - v_quantidade_retirar
    WHERE
        id_produto = :new.id_produto;
END;

-- testando a trigger 
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade)
VALUES (1, 1, 5);

-- o estoque do produto 1 deve virar 5 pois tirei 5 dele e antes era 10
SELECT * FROM produtos WHERE id_produto = 1;

/*
9. Crie uma trigger trg_auditoria que registre automaticamente qualquer alteração nas 
tabelas CLIENTES, PRODUTOS e PEDIDOS dentro de LOG_AUDITORIA. 
-- observação 
- tudo que rolar depois das alterações nas tabelas 
- CLOB é um tipo de dado no banco de dados Oracle utilizado para armazenar grandes quantidades de texto (strings) que podem ultrapassar o tamanho dos tipos de dados convencionais, como VARCHAR2.
*/

CREATE OR REPLACE TRIGGER trg_auditoria
AFTER INSERT OR DELETE OR UPDATE ON clientes
    OR AFTER INSERT OR DELETE OR UPDATE ON produtos
    OR AFTER INSERT OR DELETE OR UPDATE ON pedidos
FOR EACH ROW
DECLARE
    v_valores_antigos CLOB;
    v_valores_novos   CLOB;
BEGIN
    -- Registro para INSERT
    IF INSERTING THEN
        v_valores_novos := TO_CLOB(:NEW);  -- Pegando os valores da nova linha inserida
        v_valores_antigos := NULL;
        
        INSERT INTO log_auditoria (tabela, operacao, usuario, data_operacao, valores_antigos, valores_novos)
        VALUES (CASE
                    WHEN INSERTING AND :NEW.TABLE_NAME = 'CLIENTES' THEN 'CLIENTES'
                    WHEN INSERTING AND :NEW.TABLE_NAME = 'PRODUTOS' THEN 'PRODUTOS'
                    WHEN INSERTING AND :NEW.TABLE_NAME = 'PEDIDOS' THEN 'PEDIDOS'
                 END,
                'INSERT',
                USER,
                SYSDATE,
                v_valores_antigos,
                v_valores_novos);
    
    -- Registro para DELETE
    ELSIF DELETING THEN
        v_valores_antigos := TO_CLOB(:OLD);  -- Pegando os valores da linha excluída
        v_valores_novos := NULL;
        
        INSERT INTO log_auditoria (tabela, operacao, usuario, data_operacao, valores_antigos, valores_novos)
        VALUES (CASE
                    WHEN DELETING AND :OLD.TABLE_NAME = 'CLIENTES' THEN 'CLIENTES'
                    WHEN DELETING AND :OLD.TABLE_NAME = 'PRODUTOS' THEN 'PRODUTOS'
                    WHEN DELETING AND :OLD.TABLE_NAME = 'PEDIDOS' THEN 'PEDIDOS'
                 END,
                'DELETE',
                USER,
                SYSDATE,
                v_valores_antigos,
                v_valores_novos);
    
    -- Registro para UPDATE
    ELSIF UPDATING THEN
        v_valores_antigos := TO_CLOB(:OLD);  -- Pegando os valores antigos
        v_valores_novos := TO_CLOB(:NEW);  -- Pegando os valores novos
        
        INSERT INTO log_auditoria (tabela, operacao, usuario, data_operacao, valores_antigos, valores_novos)
        VALUES (CASE
                    WHEN UPDATING AND :NEW.TABLE_NAME = 'CLIENTES' THEN 'CLIENTES'
                    WHEN UPDATING AND :NEW.TABLE_NAME = 'PRODUTOS' THEN 'PRODUTOS'
                    WHEN UPDATING AND :NEW.TABLE_NAME = 'PEDIDOS' THEN 'PEDIDOS'
                 END,
                'UPDATE',
                USER,
                SYSDATE,
                v_valores_antigos,
                v_valores_novos);
    END IF;
END trg_auditoria;

