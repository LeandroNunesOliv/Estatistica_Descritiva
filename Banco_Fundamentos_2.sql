-- Autor: Leandro de Oliveira Nunes
-- Data ultima atualização: 07/11/2026
-- Relacionamentos, Joins, Subqueries, filtros de integridade em Banco de Dados Relacional (MySQL)

-- Mostrar bancos
SHOW DATABASES;

-- Criar o banco
CREATE database aula2;

USE aula2;

-- 1. Clientes cadastrados
CREATE TABLE clientes (
id SERIAL PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
cidade VARCHAR(60) NOT NULL,
uf CHAR(2) NOT NULL
);

-- 2. Pedidos realizados
CREATE TABLE pedidos (
id SERIAL PRIMARY KEY,
cliente_id INT REFERENCES clientes(id) ON DELETE CASCADE,
data_pedido DATE DEFAULT (CURRENT_DATE),
status VARCHAR(20) DEFAULT 'PENDENTE'
);

-- 3. Detalhes e itens por pedido (relação entre Pedidos e Produtos)
CREATE TABLE itens_pedido (
pedido_id INT REFERENCES pedidos(id) ON DELETE CASCADE,
produto_id INT REFERENCES produtos(id),
quantidade INT NOT NULL CHECK (quantidade > 0),
preco_unitario DECIMAL (10, 2) NOT NULL,
PRIMARY KEY (pedido_id, produto_id)
);

-- Criar as tabelas (colunas e o formato dos dados). Tabela usada do banco aula
CREATE TABLE produtos ( 
    id INT AUTO_INCREMENT PRIMARY KEY, 
    nome VARCHAR(100) NOT NULL, 
    categoria VARCHAR(50) NOT NULL, 
    preco DECIMAL(10,2) NOT NULL, 
    estoque INT DEFAULT 0, 
    ativo BOOLEAN DEFAULT TRUE, 
    data_cadastro DATE DEFAULT (CURRENT_DATE)
);

---------------------------------------------------------------

-- Gerando dados ficticios para testes
-- 1. CLIENTES
INSERT INTO clientes (id, nome, cidade, uf) VALUES
(1, 'Ana Souza', 'Rio de Janeiro', 'RJ'),
(2, 'Bruno Lima', 'Niterói', 'RJ'),
(3, 'Carla Mendes', 'Curitiba', 'PR'),
(4, 'Diego Santos', 'São Paulo', 'SP'),
(5, 'Elisa Costa', 'Belo Horizonte', 'MG'),
(6, 'Felipe Rocha', 'Salvador', 'BA'),
(7, 'Gabriela Alves', 'Porto Alegre', 'RS'),
(8, 'Henrique Martins', 'Recife', 'PE'),
(9, 'João Oliveira', 'Campinas', 'SP'),
(10, 'Mariana Ferreira', 'Rio de Janeiro', 'RJ'),
(11, 'Pedro Almeida', 'Curitiba', 'PR');

-- 2. PEDIDOS
INSERT INTO pedidos (id, cliente_id, data_pedido, status) VALUES
(1, 1, '2026-10-01', 'FINALIZADO'),
(2, 2, '2026-10-02', 'PENDENTE'),
(3, 1, '2026-10-05', 'FINALIZADO'),
(4, 3, '2026-10-07', 'CANCELADO'),
(5, 4, '2026-10-10', 'FINALIZADO'),
(6, 5, '2026-10-12', 'PENDENTE'),
(7, 6, '2026-10-15', 'FINALIZADO'),
(8, 2, '2026-10-18', 'FINALIZADO'),
(9, 7, '2026-10-20', 'PENDENTE'),
(10, 8, '2026-10-22', 'FINALIZADO'),
(11, 3, '2026-10-25', 'FINALIZADO'),
(12, 1, '2026-10-28', 'PENDENTE');

-- 3. ITENS DOS PEDIDOS
-- produto_id referencia produtos.id_produto
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 2, 120.00),
(1, 2, 1, 850.00),
(2, 3, 1, 75.50),
(3, 1, 1, 120.00),
(3, 4, 2, 45.00),
(4, 5, 1, 210.00),
(5, 2, 1, 850.00),
(5, 3, 2, 75.50),
(6, 4, 3, 45.00),
(7, 5, 2, 210.00),
(8, 1, 1, 120.00),
(8, 3, 3, 75.50),
(9, 2, 1, 850.00),
(10, 4, 2, 45.00),
(10, 5, 1, 210.00),
(11, 1, 2, 120.00),
(11, 2, 1, 850.00),
(12, 3, 2, 75.50);

-- 1. Inserção pontual completa. Insert usado do banco aula. Mesma tabela produtos
INSERT INTO produtos (id, nome, categoria, preco, estoque, ativo, data_cadastro)
VALUES (1,'Teclado Mecânico RGB', 'Periféricos', 289.90, 45, TRUE, '2026-01-15');

-- 2. Inserção de lote com omissão de colunas com DEFAULT. . Insert usado do banco aula. Mesma tabela produtos
INSERT INTO produtos (id, nome, categoria, preco, estoque) VALUES
(2,'Monitor 27" 144Hz', 'Monitores', 1450.00, 15),
(3,'Cadeira Ergonômica', 'Móveis', 890.00, 12),
(4,'Fone Bluetooth Over-Ear', 'Áudio', 350.00, 0),
(5,'Webcam Full HD 1080p', 'Periféricos', 210.00, 25),
(6,'Microfone Condensador USB', 'Áudio', 310.00, 18),
(7,'Cabo HDMI 2.1 2m', 'Cabos', 45.00, 150);

---------------------------------------------------------------

USE aula2;

SHOW TABLES;

-- Conferência dos registros inseridos
SELECT * FROM clientes;
SELECT * FROM pedidos;
SELECT * FROM itens_pedido;

---------------------------------------------------------------

-- Exercício 01 • Interseção Básica (INNER JOIN) 
-- Enunciado: Escreva uma consulta que retorne o código do pedido (id), a data em que foi realizado e o nome do respectivo cliente, listando apenas os pedidos cujo Status seja igual a 'FINALIZADO'
SELECT p.id AS pedido_id, p.data_pedido, c.nome AS cliente_nome
FROM pedidos p
INNER JOIN clientes c
    ON p.cliente_id = c.id
WHERE p.status = 'FINALIZADO';

-- Exercícios 02 • de (LEFT JOIN com Filtro NULL) 
-- Enunciado: O departamento de marketing precisa enviar um cupom de boas-vindas para usuários cadastrados que ainda não realizaram compras. Liste o id, nome e cidade de todos os clientes que possuem zero pedidos associados.
SELECT c.id AS cliente_id, c.nome AS cliente_nome, c.cidade
FROM clientes c
LEFT JOIN pedidos p
    ON c.id = p.cliente_id
WHERE p.id IS NULL;

-- Exercício 03 • Carrinho Completo (JOIN Triplo) 
-- Enunciado: Selecione o código do pedido, o nome do produto comercializado, a quantidade adquirida e o preço unitário praticado na venda. Ordene o resultado pelo código do pedido em ordem ascendente.
SELECT ip.pedido_id, prod.nome AS produto, ip.quantidade, ip.preco_unitario
FROM itens_pedido ip
INNER JOIN produtos prod
    ON ip.produto_id = prod.id
ORDER BY ip.pedido_id ASC;

-- Exercício 04 • Valor Total por Pedido (JOIN + GROUP BY)
-- Enunciado: Gere um relatório com o código do pedido, a data da compra e o valor_total_pedido (calculado como a soma de quantidade vezes o preço unitário de cada item). Ordene do maior faturamento para o menor.
SELECT p.id AS pedido_id, p.data_pedido,
 SUM(ip.quantidade * ip.preco_unitario) AS valor_total_pedido
FROM pedidos p
INNER JOIN itens_pedido ip ON p.id = ip.pedido_id
GROUP BY p.id, p.data_pedido
ORDER BY valor_total_pedido DESC;

-- Exercício 05 • Filtro com Subquery Escalar	 INTERMEDIÁRIO
-- Enunciado: Localize 0 nome e 0 preço de todos os produtos cujo preço de venda seja estritamente superior ao preço médio de todos os produtos da categoria 'periféricos'.
SELECT nome, preco
FROM produtos
WHERE preco > (
    SELECT AVG(preco)
    FROM produtos
    WHERE categoria = 'Periféricos'
);

-- Exercícios 06 • Subquery Correlacionada com NOT EXISTS 	AVANÇADO
-- Enunciado: Exiba o id, nome e categoria de todos os produtos do catálogo que nunca figuraram em nenhum item de pedido registrado na tabela itens_pedido, utilizando obrigatoriamente a cláusula NOT EXISTS.
SELECT id, nome, categoria
FROM produtos prod
WHERE NOT EXISTS (
    SELECT 1
    FROM itens_pedido ip
    WHERE ip.produto_id = prod.id
);

-- Exercício 07 • Subquery com Operador IN em conjuntos	INTERMEDIÁRIO
-- Enunciado: Retorne os nomes de todos os clientes que já compraram ao menos um produto pertencente à categoria 'Monitores', utilizando uma subquery com o predicado IN.
SELECT nome
FROM clientes
WHERE id IN (
    SELECT p.cliente_id FROM pedidos p
    INNER JOIN itens_pedido ip ON p.id = ip.pedido_id
    INNER JOIN produtos prod ON ip.produto_id = prod.id
    WHERE prod.categoria = 'Monitores'
);

-- Exercício 08 • Faturamento por Categoria (Junção + Agregação)	 AVANÇADO
-- Enunciado: Calcule a receita bruta total auferida por cada categoria de produto em pedidos concluídos (status = 'FINALIZADO'). Exiba o nome da categoria e o total faturado, ordenando pelo maior montante financeiro.
SELECT 
prod.categoria,
SUM(ip.quantidade * ip.preco_unitario) AS receita_bruta
FROM produtos prod
INNER JOIN itens_pedido ip ON prod.id = ip.produto_id
INNER JOIN pedidos p ON ip.pedido_id = p.id
WHERE p.status = 'FINALIZADO'
GROUP BY prod.categoria
ORDER BY receita_bruta DESC;

-- Exercício 09 • Clientes Recorrentes com HAVING em JOIN 	INTERMEDIÁRIO
-- Enunciado: Apresente o nome do cliente e a quantidade total de pedidos efetuados, exibindo apenas clientes que já realizaram 2 ou mais pedidos na plataforma comercial.
SELECT c.nome, COUNT(p.id) AS total_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nome
HAVING COUNT(p.id) >= 2;

-- Exercício 10 • Desafio Corporativo com CTE (Common Table Expression)   AVANÇADO
-- Enunciado: Utilizando a cláusula WITH, crie uma CTE chamada compras_cliente que calcule o gasto total acumulado de cada cliente. Na consulta principal, exiba os clientes que gastaram acima da média de gastos de
-- todos os clientes compradores.
WITH faturamento_por_cliente AS (
SELECT 
c.id, c.nome,
SUM(ip.quantidade * ip.preco_unitario) AS gasto_total
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
INNER JOIN itens_pedido ip ON p.id = ip.pedido_id
GROUP BY c.id, c.nome
)
SELECT id, nome, gasto_total
FROM faturamento_por_cliente
WHERE gasto_total > (
SELECT AVG(gasto_total) FROM faturamento_por_cliente
)
ORDER BY gasto_total DESC;
