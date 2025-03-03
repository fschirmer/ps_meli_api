# Meli

## Challenge Engineer - Primera Parte - SQL

Abaixo descrevo o processo realizado para solucionar esta etapa do Challenge.

1. Realizar a busca do produto
   
    A função **get_item_ids** recebe como parâmetro o produto a ser procurado, o limite de ofertas por página e o limite de resultados.

2. Obter dados de cada oferta

   Com o resultado de get_item_ids a função **get_item_details** obtém o resultado de cada oferta.

3. Escrever os resultados

   Os campos que considerei importantes para a análise foram: id, title ,price, condition, category_id, seller_id, currency_id e attributes.value_name. O campo attributes.value_name somente extrai os dados onde o attributes.id é igual a RAM_MEMORY e MODEL. Os resultados foram salvos no arquivo [produtos.csv](api/produtos.csv)


    
    
https://docs.google.com/presentation/d/1GbLPwOG3d5BOqqlZnGjATcRd9tjcHffdMyvqAJOyNEc/edit?usp=sharing