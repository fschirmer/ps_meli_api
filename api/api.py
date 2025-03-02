import requests
import csv
import time
from requests.utils import quote


# Função para realizar a consulta e obter os item_ids
def get_item_ids(query, limit=50, max_items=150):
    item_ids = []
    offset = 0
    encoded_query = quote(query)  # Codificar query corretamente

    while len(item_ids) < max_items:
        url = f'https://api.mercadolibre.com/sites/MLA/search?q={encoded_query}&limit={limit}&offset={offset}'
        response = requests.get(url)
        data = response.json()

        if "results" not in data:
            print(f'Nenhum resultado encontrado para: {query}')
            break

        # Adicionar os item_ids dos resultados da página atual
        item_ids.extend([item['id'] for item in data['results']])

        # Atualiza o offset para buscar a próxima página
        offset += limit

        # Se já atingimos o número máximo de itens, interrompe
        if len(item_ids) >= max_items:
            break

        # Aguardar 1 segundo para não sobrecarregar a API
        time.sleep(1)

    return item_ids[:max_items]  # Retorna exatamente max_items


# Função para pegar os detalhes de um item
def get_item_details(item_id):
    url = f'https://api.mercadolibre.com/items/{item_id}'
    response = requests.get(url)
    return response.json()

def extract_attribute_value(data, attribute_id):
    for attribute in data['attributes']:
        # Verificando se o nome do atributo bate com o que procuramos
        if attribute.get('id') == attribute_id:
            # Retorna o valor correspondente
            return attribute.get('value_name', '')
    return None

# Função para escrever os dados no arquivo CSV
def write_to_csv(item_data_list, filename='produtos.csv'):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)

        # Escrever cabeçalhos do CSV
        writer.writerow(
            ['query', 'item_id', 'title', 'price', 'condition', 'category_id', 'seller_id',
             'currency', 'ram_memory', 'model'])

        # Escrever os dados dos produtos
        for item_data in item_data_list:
            writer.writerow(item_data)


# Lista de termos de pesquisa
search_queries = ['Chromecast', 'Apple TV', 'Amazon Fire TV']
# search_queries = ['Google Home']

# Lista para armazenar todos os resultados
all_items_data = []

# Iterar sobre cada termo de busca
for search_query in search_queries:
    print(f'Buscando produtos para: {search_query}')

    # Passo 1: Obter os item_ids para o termo atual
    # item_ids = get_item_ids(search_query.replace(' ', '%20'))  # Substituir espaço por '+'
    item_ids = get_item_ids(search_query)

    # Passo 2: Obter os detalhes de cada item
    for item_id in item_ids:
        item_data = get_item_details(item_id)

        # Extração dos valores
        ram_memory = extract_attribute_value(item_data, "RAM_MEMORY")
        model = extract_attribute_value(item_data, "MODEL")

        # Extrair as informações relevantes e adicionar o termo pesquisado
        item_info = [
            search_query,  # Adiciona o termo da pesquisa
            item_data.get('id', ''),
            item_data.get('title', ''),
            item_data.get('price', ''),
            item_data.get('condition', ''),
            item_data.get('category_id', ''),
            item_data.get('seller_id', ''),
            item_data.get('currency_id', ''),
            ram_memory,
            model
        ]

        all_items_data.append(item_info)
    print(f'Fechando produtos para: {search_query}')

# Passo 3: Escrever os dados no CSV
write_to_csv(all_items_data)

print('Dados escritos em produtos.csv')
