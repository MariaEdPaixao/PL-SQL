SELECT
    *
FROM
    pais;

-- colocando o alias fica mais simples
-- Padrão ANSI
SELECT
    a.nome_pais          pais,
    COUNT(b.nome_estado) "QDT ESTADOS"
FROM
         pais a
    INNER JOIN estado b ON ( a.id_pais = b.id_pais )
GROUP BY
    a.nome_pais;

--igual ao de cima
SELECT 
    a.nome_pais pais,
    COUNT(b.nome_estado) "QTD ESTADO"
FROM 
    pais a, 
    estado b
WHERE 
    a.id_pais = b.id_pais
GROUP BY 
    a.nome_pais;
    
-- Todos os paises, inclusive os que não tem estados cadastrados
SELECT
    a.nome_pais pais,
    COUNT(b.nome_estado) "QTD ESTADOS"
FROM 
    pais a
    LEFT JOIN estado b ON (a.id_pais = b.id_pais)
GROUP BY
    a.nome_pais
HAVING COUNT(b.nome_estado) BETWEEN 1 AND 5

ORDER BY 2 DESC; -- ordem crescente | DESC ordem decrescente 
-- ESSE 2 MOSTRA POR QUAL COLUNA QUERO ORDENAR
    
-- paises que tenham mais de 5 estados
SELECT
    a.nome_pais pais,
    COUNT(b.nome_estado) "QTD ESTADOS"
FROM 
    pais a
    LEFT JOIN estado b ON (a.id_pais = b.id_pais)
GROUP BY
    a.nome_pais
HAVING COUNT(b.nome_estado) > 5

ORDER BY 2 DESC; -- ordem crescente | DESC ordem decrescente 
-- ESSE 2 MOSTRA POR QUAL COLUNA QUERO ORDENAR

-- quantas cidades cada estado tem
-- Funçao de agregação -> obrigatoriamente precisa usar GROUP BY
SELECT
    a.nome_estado          estado,
    COUNT(b.nome_cidade) "QDT CIDADES"
FROM
         estado a
    INNER JOIN cidade b ON ( a.id_estado = b.id_estado ) -- comparando PK(de estado) com FK(cidade), comparando se são iguais e trazendo
GROUP BY
    a.nome_estado;

SELECT 
    a.nome_pais pais, 
    b.nome_estado estado,
    COUNT(c.nome_cidade) "QTD_CIDADES"
FROM
    pais a 
    JOIN estado b ON (a.id_pais = b.id_pais)
    LEFT JOIN cidade c ON (b.id_estado = c.id_estado)
GROUP BY 
    a.nome_pais,
    b.nome_estado
    
ORDER BY 3 DESC,1,2;

SELECT * FROM cidade;
SELECT * FROM estado;
-- Padrão não ANSI (Oracle), o + ele entende que é left join 
SELECT
    a.nome_pais pais,
    COUNT(b.nome_estado) "QTD ESTADOS"
FROM 
    pais a
    LEFT JOIN estado b ON (+)
GROUP BY
    a.nome_pais;
    
------------------------------ prof    
SELECT 
    a.nom_pais pais, 
    b.nom_estado estado,
    COUNT(c.nom_cidade) "QTD_CIDADES"
FROM
    PF1788.pais a 
    JOIN PF1788.estado b ON (a.cod_pais = b.cod_pais)
    LEFT JOIN PF1788.cidade c ON (b.cod_estado = c.cod_estado)
GROUP BY 
    a.nom_pais,
    b.nom_estado
    
ORDER BY 3 DESC,1,2;