from SeleniumStrategy import SeleniumStrategy
from BeautifulSoupStrategy import BeautifulSoupStrategy

import yaml

output_filename = 'output.yaml'
if __name__ == '__main__':
    print('Starting...')

    my_strategy = BeautifulSoupStrategy()
    dictionary = my_strategy.scrape_page()
    print(len(dictionary.keys()))
    with open(output_filename, 'w') as file:
        yaml.dump(dictionary, file)

    print('Finished!')


