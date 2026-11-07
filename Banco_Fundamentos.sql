
-- Autor: Leandro de Oliveira Nunes
-- Data ultima atualização: 01/11/2026
-- Fundamentos, CRUD, Joins, Subqueries e Análises de Banco de Dados Relacional (MySQL)

-- Mostrar bancos
SHOW DATABASES;

-- Criar o banco
CREATE	database aula;

USE aula;

-- Criar as tabelas (colunas e o formato dos dados)
CREATE TABLE produtos ( 
    id INT AUTO_INCREMENT PRIMARY KEY, 
    nome VARCHAR(100) NOT NULL, 
    categoria VARCHAR(50) NOT NULL, 
    preco DECIMAL(10,2) NOT NULL, 
    estoque INT DEFAULT 0, 
    ativo BOOLEAN DEFAULT TRUE, 
    data_cadastro DATE DEFAULT (CURRENT_DATE)
);

SELECT * FROM PRODUTOS;

-- 1. Inserção pontual completa
INSERT INTO produtos (id, nome, categoria, preco, estoque, ativo, data_cadastro)
VALUES (1,'Teclado Mecânico RGB', 'Periféricos', 289.90, 45, TRUE, '2026-01-15');

SELECT * FROM PRODUTOS;

-- 2. Inserção de lote com omissão de colunas com DEFAULT
INSERT INTO produtos (id, nome, categoria, preco, estoque) VALUES
(2,'Monitor 27" 144Hz', 'Monitores', 1450.00, 15),
(3,'Cadeira Ergonômica', 'Móveis', 890.00, 12),
(4,'Fone Bluetooth Over-Ear', 'Áudio', 350.00, 0),
(5,'Webcam Full HD 1080p', 'Periféricos', 210.00, 25),
(6,'Microfone Condensador USB', 'Áudio', 310.00, 18),
(7,'Cabo HDMI 2.1 2m', 'Cabos', 45.00, 150);

SELECT * FROM PRODUTOS;

-- Atualização de Registros (Update • UPDATE)

-- 1. Alteração pontual com base na Chave Primária (PK)
UPDATE produtos SET preco = 269.90, estoque = 40 WHERE id = 1;

SELECT * FROM PRODUTOS;

-- 2. Reajuste inflacionário de 10% apenas para categoria ativa
SET SQL_SAFE_UPDATES = 0;
UPDATE produtos 
SET preco = round(preco * 1.10, 2) 
WHERE categoria = 'Periféricos' AND ativo = TRUE;

SELECT * FROM PRODUTOS;

-- 3. Inativação automática baseada em regra de estoque
UPDATE produtos SET ativo = FALSE WHERE estoque = 0;

SELECT * FROM PRODUTOS;

-- 4. Remoção cirúrgica com múltiplos predicados
DELETE FROM produtos WHERE ativo = FALSE AND estoque = 0;
-- INSERT INTO produtos (id, nome, categoria, preco, estoque, ativo, data_cadastro) VALUES (4, 'Fone Bluetooth Over-Ear', 'Áudio', 350.00, 0, TRUE, '2026-11-01');

SELECT * FROM PRODUTOS;

--------------------------------------------------------------

-- O Motor de Consultas: SELECT Essencial & Filtros

-- Consulta Iimpa com cálculo patrimonial e simulação de pagamento à vista (-15%)
SELECT
    nome AS produto,
    preco AS preco_cheio,
    estoque,
    (preco * estoque) AS valor_total_em_estoque,
ROUND(preco * 0.85, 2) AS preco_pix_desconto
FROM produtos;

SELECT * FROM PRODUTOS;

-- Precedência explicita com parênteses em expressões combinadas
SELECT id, nome, categoria, preco
FROM produtos
WHERE (categoria = 'Áudio' OR categoria = 'Monitores')
  AND preco >= 300.00
  AND ativo = TRUE;

SELECT * FROM PRODUTOS;

-- 1. Faixas de valores contínuos (inclusivo)
SELECT nome, preco FROM produtos WHERE preco BETWEEN 100.00 AND 450.00;

-- 2. Pertencimento a conjuntos discretos
SELECT nome, categoria FROM produtos WHERE categoria IN ('Áudio', 'Móveis');

-- 3. Reconhecimento de padrões em strings (%: qualquer caractere)
SELECT nome, preco FROM produtos WHERE nome LIKE '%Sem Fio%';
-- Obs: Não existe nenhum produto cadastrado com o texto "Sem Fio" no nome.

-- 4. Verificação de nulidade (nunca use = NULL)
SELECT nome FROM produtos WHERE estoque IS NULL OR estoque = 0;
-- Obs: Todos os produtos cadastrados atualmente possuem alguma quantidade no estoque e os que não tem foram deletados anteriormente para analise e testes das funcionalidades

--------------------------------------------------------------

-- Agrupamentos, Métricas e Ordem de Execução

-- Paginação técnica (Página 2 exibindo 3 registros por requisição)
SELECT id, nome, preco
FROM produtos
WHERE ativo = TRUE
ORDER BY preco DESC, id Asc
LIMIT 3 OFFSET 3;

-- Resumo financeiro e volumetria por categoria (Preço Médio > 200)
SELECT
    categoria,
    COUNT(*) AS total_produtos,
    SUM(estoque) AS pecas_totais,
    ROUND(AVG(preco), 2) AS preco_medio
FROM produtos
WHERE ativo = TRUE
GROUP BY categoria
HAVING AVG(preco) > 200.00
ORDER BY preco_medio DESC;

--------------------------------------------------------------

-- Exercício 01 • Inserção pontual (Create) 
-- Enunciado: Cadastre um novo produto com o nome 'Mousepad Gamer Extra Grande' , categoria 'Acessórios', valor unitário de 89.90, com 60 unidades em estoque e Status TRUE.

INSERT INTO produtos (nome, categoria, preco, estoque, ativo)
VALUES ('Mousepad Gamer Extra Grande', 'Acessórios', 89.90, 60, TRUE);

SELECT * FROM PRODUTOS;
SELECT * FROM produtos WHERE nome LIKE '%Mousepad%';

-- Exercício 02 • Modificação Condicional (Update)
-- Enunciado: Conceda um desconto de 15% sobre o preço atual de todos os itens cadastrados sob a categoria ' Áudio ' cujo preço original seja superior a 300.00. Arredonde o resultado em 2 casas decimais.

UPDATE produtos SET preco = ROUND(preco * 0.85, 2)
WHERE categoria = 'Áudio' AND preco > 300.00;

SELECT * FROM PRODUTOS;
SELECT * FROM produtos WHERE categoria = 'Áudio';

-- Exercício 03 • Exclusão Controlada (Delete)
-- Enunciado: Remova do catálogo os registros que estejam inativos (ativo = FALSE), que pertençam à categoria 'Acessórios' e cujo estoque esteja zerado.

DELETE FROM produtos 
WHERE ativo = FALSE 
  AND categoria = 'Acessórios' 
  AND estoque = 0;
  
SELECT * FROM PRODUTOS;
SELECT * FROM produtos WHERE ativo = FALSE AND categoria = 'Acessórios' AND estoque = 0;

-- Exercício 04 • Projeção e Ordenação (Read)
-- Enunciado: Recupere as colunas nome, preço e estoque de todos os itens ativos, ordenados do produto de maior valor para o de menor valor comercial.

SELECT nome, preco, estoque
FROM produtos
WHERE ativo = TRUE
ORDER BY preco DESC;

-- Exercício 05 • Filtragem por Intervalo e Negação
-- Enunciado: Selecione os campos nome, preco e categoria para os produtos cujo preço situe-se entre 150.00 e 500.00 (inclusivo), excluindo a categoria 'Móveis'.

SELECT nome, preco, categoria 
FROM produtos
WHERE preco BETWEEN 150.00 AND 500.00
AND categoria != 'Móveis';

-- Exercício 06 • Reconhecimento de Padrão Textual 
-- Enunciado: Selecione todas as colunas dos produtos cujo nome contenha o termo 'Monitor' ou o termo 'USB' em qualquer posição textual (sem considerar distinção de chave primária)

SELECT *
FROM produtos
WHERE nome LIKE '%Monitor%'
   OR nome LIKE '%USB%';
   
-- Exercício 07 • Consolidação Estatística GlobaL
-- Enunciado: Escreva uma consulta que apresente em uma única linha o número total de itens cadastrados, a soma do estoque físico total e a média geral de preço com 2 casas decimais.

SELECT 
    COUNT(*) AS total_cadastrado,
    SUM(estoque) AS volume_estoque,
    ROUND(AVG(preco), 2) AS preco_medio
FROM produtos;

-- Exercício 08 • Agrupamento por Categoria (GROUP BY)
-- Enunciado: Monte um demonstrativo contendo o nome de cada categoria, o total de itens ativos existentes nela e o maior preço unitário verificado em cada uma.

SELECT categoria,
    COUNT(*) AS total_ativos,
    MAX(preco) AS maior_preco
FROM produtos
WHERE ativo = TRUE
GROUP BY categoria;

-- Exercício 09 • Filtragem sobre Grupos (HAVING)
-- Enunciado: Exiba o nome da categoria e o somatório de unidades em estoque exclusivamente para os grupos que acumularem mais de 50 itens físicos armazenados.

SELECT categoria, SUM(estoque) AS estoque_total
FROM produtos
GROUP BY categoria
HAVING SUM(estoque) > 50;

-- Exercício 10 • Relatório Paginado com Cálculo Comercial
-- Enunciado: Projete a primeira página de um catálogo eletrônico contendo apenas itens com estoque disponível (estoque > 0). Exiba id, nome, preco e o valor de cada prestação em 10 parcelas sem juros (preco / 10), ordenado por preço crescente e limitado a 4 itens.

SELECT id, nome, preco,
  ROUND(preco / 10.0, 2) AS preco_parcelado_10x
FROM produtos
WHERE estoque > 0
ORDER BY preco ASC
LIMIT 4 OFFSET 0;
