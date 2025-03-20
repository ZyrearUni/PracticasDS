from Strategist import Strategist
from bs4 import BeautifulSoup
import requests


class BeautifulSoupStrategy(Strategist):
    def __init__(self, page_total):
        super().__init__(page_total)

    def scrape_page(self):
        quotes = []
        authors = []
        tags = []
        for i in range(1, self.page_total + 1):
            URL = "https://quotes.toscrape.com/page/" + str(i) + "/"
            page = requests.get(URL)

            soup = BeautifulSoup(page.content, "html.parser")

            # Usually it would be better to scrape the div with class='quote' containing
            # all the information of a quote and then subdivide it (might be more efficient)
            # but in this case search efficiency isn't that important
            # this code is more readable

            res_quotes = soup.find_all('span', attrs={'class': 'text', 'itemprop': 'text'})

            for quote in res_quotes:
                quotes.append(quote.text[1:-1])  # [1:-1] used to remove " "  (unicode characters)

            res_authors = soup.find_all('small', attrs={'class': 'author', 'itemprop': 'author'})

            for author in res_authors:
                authors.append(author.text)

            res_tags = soup.find_all('div', attrs={'class': 'tags'})

            for r_tag_list in res_tags:
                tags_per_quote = r_tag_list.find_all('a', attrs={'class': 'tag'})
                tag_list = []
                for t in tags_per_quote:
                    tag_list.append(t.text)
                tags.append(tag_list)

        # Now I have in quotes, authors and tags the information I need
        # Ex. quotes[0] was written by authors[0] and its tags are tags[0]
        # (where tags is a list of lists)

        # in case of a bigger scrapping it would be safer to store data to file while scrapping, to avoid
        # loosing data in case of error, but being a simple example we did it in main to keep the class
        # system more structured

        dictionary = self.process_into_dict(quotes, authors, tags)

        return dictionary
