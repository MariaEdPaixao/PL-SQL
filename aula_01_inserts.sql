-- Inserções dos países
INSERT INTO pais (id_pais, nome_pais) VALUES (1, 'Brasil');
INSERT INTO pais (id_pais, nome_pais) VALUES (2, 'México');
INSERT INTO pais (id_pais, nome_pais) VALUES (3, 'Tailândia');
INSERT INTO pais (id_pais, nome_pais) VALUES (4, 'Espanha');
INSERT INTO pais (id_pais, nome_pais) VALUES (5, 'Chile');

-- Inserções dos estados
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (1, 'Chiang Mai', 3);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (2, 'São Paulo', 1);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (3, 'Jalisco', 2);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (4, 'Região de Valparaíso', 5);
INSERT INTO estado (id_estado, nome_estado, id_pais) VALUES (5, 'Andaluzia', 4);

-- Inserções das cidades
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (1, 'Fang', 1);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (2, 'Viña del Mar', 4);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (3, 'Guadalajara', 3);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (4, 'Sevilha', 5);
INSERT INTO cidade (id_cidade, nome_cidade, id_estado) VALUES (5, 'Sorocaba', 2);

-- Inserções dos bairros corrigidos
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (1, 'Tambon Mae Ngat', 1); -- Fang (Tailândia)
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (2, 'Reñaca', 2); -- Viña del Mar (Chile)
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (3, 'Colonia Americana', 3); -- Guadalajara (México)
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (4, 'Triana', 4); -- Sevilha (Espanha)
INSERT INTO bairro (id_bairro, nome_bairro, id_cidade) VALUES (5, 'Jardim São Paulo', 5); -- Sorocaba (Brasil)
