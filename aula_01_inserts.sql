-- Inser��es dos pa�ses
INSERT INTO pais (id_pais, nome_pais) VALUES (1, 'Brasil');
INSERT INTO pais (id_pais, nome_pais) VALUES (2, 'M�xico');
INSERT INTO pais (id_pais, nome_pais) VALUES (3, 'Tail�ndia');
INSERT INTO pais (id_pais, nome_pais) VALUES (4, 'Espanha');
INSERT INTO pais (id_pais, nome_pais) VALUES (5, 'Chile');

-- Inser��es dos estados
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (1, 'Chiang Mai', 3);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (2, 'S�o Paulo', 1);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (3, 'Jalisco', 2);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (4, 'Regi�o de Valpara�so', 5);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (5, 'Andaluzia', 4);

-- Inser��es das cidades
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (1, 'Fang', 1);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (2, 'Vi�a del Mar', 4);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (3, 'Guadalajara', 3);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (4, 'Sevilha', 5);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (5, 'Sorocaba', 2);

-- Inser��es dos bairros corrigidos
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (1, 'Tambon Mae Ngat', 1); -- Fang (Tail�ndia)
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (2, 'Re�aca', 2); -- Vi�a del Mar (Chile)
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (3, 'Colonia Americana', 3); -- Guadalajara (M�xico)
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (4, 'Triana', 4); -- Sevilha (Espanha)
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (5, 'Jardim S�o Paulo', 5); -- Sorocaba (Brasil)
