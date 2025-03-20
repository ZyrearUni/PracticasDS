from SeleniumStrategy import SeleniumStrategy
from BeautifulSoupStrategy import BeautifulSoupStrategy

import yaml

output_filename = 'output.yaml'
if __name__ == '__main__':
    print('Starting...')

    my_strategy = None
    while my_strategy is None:
        scrapper = input('Please choose which scrapper you want to use:')
        sel_names = ['selenium', 'seleniumstrategy', 'sel']
        beau_names = ['beautifulsoup', 'beautifulsoupstrategy', 'beau']

        if scrapper.lower() in sel_names:
            my_strategy = SeleniumStrategy(5)
        elif scrapper.lower() in beau_names:
            my_strategy = BeautifulSoupStrategy(5)

    dictionary = my_strategy.scrape_page()

    print(len(dictionary.keys()))
    with open(output_filename, 'w') as file:
        # additional option needed to handle long quotes
        yaml.safe_dump(dictionary, file, default_flow_style=False, width=2**10)

    print('Finished!')


