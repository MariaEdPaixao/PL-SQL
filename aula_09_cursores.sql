-- Cursores
-- implicito: select
 
-- o banco de dados tem uma area especifica para executar cursores -> bd prioriza cursores
 
/*
Tipos de cursores
 
-- Explícitos -> executa area reservada
 
-- Implícitos: select, update, delete (begin, end) -> executa por fila
 
Cursor na memoria, quando preciso de desempenho, movimentação de dados mto rapido,
*/
 
CREATE TABLE HISTORICO (
    COD_PRODUTO NUMBER, 
    NOME_PRODUTO VARCHAR2(50),
    DATA_MOVIMENTACAO DATE
);
 
-- Criando cursor explicito 
SET SERVEROUTPUT ON;
 
DECLARE
          -- herdando o tipo do atributo: declaração do tipo da herença 
  v_codigo PRODUTO.cod_produto%type := 12349;
  cursor cur_emp IS
    SELECT nom_produto FROM produto WHERE cod_produto = v_codigo;
BEGIN
  FOR x IN cur_emp LOOP
    INSERT into HISTORICO VALUES (v_codigo, x.nom_produto, sysdate);
    COMMIT;
  END LOOP;
END;
 
select * from produto;
 
-- Usar cursor: extenso -> quando precisa tem controle exato de tudo/de cada linha |  resumido -> na maioria das vezes é usado (joga o bloco todo)
-- Navegação no cursor, é sempre na proxima linha 
-- Open/fetch para cursor extenso
 
/*
    ** Variáveis dos cursores: ** 
    - Nomedocursor%rowcount : devolve o numero da linha processada até o momento (formato completo ou resumido)
    - NomedoCursor%isopen : retorna true ou false para determinar se um cursor está aberto ou não (formato completo)
    - NomedoCursor%found : retorna true ou false para determinar se um registro foi encontrado ou não (formato completo)
    - NomedoCursor%notfound : retorna true ou false para determinar se um registro  NÃO foi encontrado (formato completo)
 
    **Cursores com parâmetros**
    para aumentar o dinamismo do funcionamento do mesmo, recuperando de forma dinâmica apenas os registros que satisfaçam as condições passadas através dos parâmetros.

    Sintaxe:
        Cursor  nome_do_cursor (param1 tipo[, param2 tipo,... ParamN tipo]) is
        Select .... From .... Where  col = param1...;
    Exemplo:
        Cursor c_emp (p_código   empregados.código%type) is
         select * from empregados where código = p_código;
*/
 
/*
    - Current of
    - For update 
    - NoWait - o registro recuperado vai ficar em espera 
    - RowID - identificador do posicionamento do atributo no disco, porém pode mudar, então nao devemos usar
 
    - Cursores encadeados
*/
 
select rowid, x.* from cliente x