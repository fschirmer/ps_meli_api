/* O Apple TV é o que possui menos ofertas no Mercado Livre */
SELECT
	query,
	count(*) AS total_query,
    SUM(COUNT(*)) OVER () AS total_geral,
    (COUNT(*) * 100.0) / SUM(COUNT(*)) OVER () AS percentual
FROM produtos GROUP BY query ORDER BY 1, 2;


/* 80% das ofertas dos produtos pesquisados são de produtos novos */
SELECT
	condition,
	count(*) AS total_query,
    SUM(COUNT(*)) OVER () AS total_geral,
    (COUNT(*) * 100.0) / SUM(COUNT(*)) OVER () AS percentual
FROM produtos GROUP BY condition ORDER BY 1, 2;

/* Apesar de 80% das ofertas dos produtos pesquisados serem de produtos novos, no caso da Apple TV,
 * 81% das ofertas são de produtos usados */
SELECT
	query,
	condition,
	COUNT(*) AS total_query,
    SUM(COUNT(*)) OVER (PARTITION BY query) AS total_query,
    (COUNT(*) * 100.0) / SUM(COUNT(*)) OVER (PARTITION BY query) AS percentual
FROM produtos GROUP BY query, condition ORDER BY 1, 2;

/* Dentre as ofertas pesquisadas, o Amazon Fire Stick é o que apresenta a menor variedade de modelos, e 
 * Chromecast o que mais apresenta a maior variedade de modelos */
WITH totalModelos AS (
	SELECT
		query,
		model,
		COUNT(*) AS total_query_model
	FROM produtos GROUP BY query, model
)
SELECT query, COUNT(DISTINCT model), SUM(total_query_model), (CAST(COUNT(DISTINCT model) AS DECIMAL)/CAST(SUM(total_query_model) AS DECIMAL))
FROM totalModelos
GROUP BY query
ORDER BY 1, 2;

/* O produto com a maior diferença entre o mais barato e o mais caro é o Chromecast novo
 * O produto com o maior valor médio é o Chromecast novo */
SELECT
	query,
	condition,
	COUNT(*) AS total_query_condition,
	MIN(price) min_price,
	MAX(price) max_price,
	MAX(price) - MIN(price) dif_max_min_price,
	AVG(price) avg_price,
	STDEVP(price) AS desvio_padrao_populacional
FROM produtos GROUP BY query, condition ORDER BY 1, 2;

/* Analisando a diferença de preço entre os produtos e a quantidade de modelos diferentes, 
 * logo se constata produtos que não são de mesmas características, mas sim similares. Exemplo: A consulta 
 * Chromecast retorna como resultado: Xiaomi Mi Tv Stick Mdz-27-eu 4k Uhd Conversor Smart Tv Andro, 
 * Tv Stick 4k | Convertidor Smart Tv Box Android Tv, Tv Box Smart Z8pro 32gb El Mas Rapido Full Apps!! e 
 * outros. */
SELECT
	query,
	condition,
	title, 
	model,
	ram_memory,
	COUNT(*) AS total_query_condition,
	MIN(price) min_price,
	MAX(price) max_price,
	MAX(price) - MIN(price) dif_max_min_price,
	AVG(price) avg_price,
	STDEVP(price) AS desvio_padrao_populacional
FROM produtos GROUP BY query, condition, title, model, ram_memory ORDER BY 1, 2;

/* Conclusão: Uma pesquisa com mais detalhes ajuda a filtrar os resultados pelo produto específico que se deseja, 
 * isto diminui a quantidade de registros retornados e facilita a comparação de produtos que são iguais. 
 * Mesmo assim, alguns produtos ainda são preenchdios de maneira errônea e a visualização mais detalhada 
 * do anúncio, inclusive da imagem do produto, ajuda a sanar dúvidas quanto ao produto que se busca. */

