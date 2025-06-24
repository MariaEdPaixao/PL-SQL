-- Cursores
-- implicito: select
 
-- o banco de dados tem uma area especifica para executar cursores -> bd prioriza cursores
 
/*
Tipos de cursores
 
-- Expl�citos -> executa area reservada
 
-- Impl�citos: select, update, delete (begin, end) -> executa por fila
 
Cursor na memoria, quando preciso de desempenho, movimenta��o de dados mto rapido,
*/
 
CREATE TABLE HISTORICO (
    COD_PRODUTO NUMBER, 
    NOME_PRODUTO VARCHAR2(50),
    DATA_MOVIMENTACAO DATE
);
 
-- Criando cursor explicito 
SET SERVEROUTPUT ON;
 
DECLARE
          -- herdando o tipo do atributo: declara��o do tipo da heren�a 
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
 
-- Usar cursor: extenso -> quando precisa tem controle exato de tudo/de cada linha |  resumido -> na maioria das vezes � usado (joga o bloco todo)
-- Navega��o no cursor, � sempre na proxima linha 
-- Open/fetch para cursor extenso
 
/*
    ** Vari�veis dos cursores: ** 
    - Nomedocursor%rowcount : devolve o numero da linha processada at� o momento (formato completo ou resumido)
    - NomedoCursor%isopen : retorna true ou false para determinar se um cursor est� aberto ou n�o (formato completo)
    - NomedoCursor%found : retorna true ou false para determinar se um registro foi encontrado ou n�o (formato completo)
    - NomedoCursor%notfound : retorna true ou false para determinar se um registro  N�O foi encontrado (formato completo)
 
    **Cursores com par�metros**
    para aumentar o dinamismo do funcionamento do mesmo, recuperando de forma din�mica apenas os registros que satisfa�am as condi��es passadas atrav�s dos par�metros.

    Sintaxe:
        Cursor  nome_do_cursor (param1 tipo[, param2 tipo,... ParamN tipo]) is
        Select .... From .... Where  col = param1...;
    Exemplo:
        Cursor c_emp (p_c�digo   empregados.c�digo%type) is
         select * from empregados where c�digo = p_c�digo;
*/
 
/*
    - Current of
    - For update 
    - NoWait - o registro recuperado vai ficar em espera 
    - RowID - identificador do posicionamento do atributo no disco, por�m pode mudar, ent�o nao devemos usar
 
    - Cursores encadeados
*/
 
select rowid, x.* from cliente x