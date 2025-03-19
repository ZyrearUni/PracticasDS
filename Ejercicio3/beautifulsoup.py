from strategist import strategist
from bs4 import BeautifulSoup
import requests

class beautifulSoup (strategist): # FIXME classname is very similar to the module. This caused an error (which I fixed)
    def __init__(self):
        super().__init__()

    # override
    def scrapePage(self):
        i = 1

        while i <= self.page_total:
            URL = "https://quotes.toscrape.com/page/" + str(i) + "/"
            page = requests.get(URL)

            soup = BeautifulSoup(page.content, "html.parser")

            res_quotes = soup.find_all('span', attrs = {'class': 'text', 'itemprop': 'text'})
            quotes = []
            for quote in res_quotes:
                quotes.append(quote.text)

            res_authors = soup.find_all('small', attrs={'class': 'author', 'itemprop': 'author'})
            authors = []
            for quote in res_authors:
                authors.append(quote.text)

            res_tags = soup.find_all('div', attrs = {'class': 'tags'})
            # do we need something more robust? This seems to work

            tags = []
            for r_tag_list in res_tags:
                tags_per_quote = r_tag_list.find_all('a', attrs = {'class': 'tag'})
                tag_list = []
                for t in tags_per_quote:
                    tag_list.append(t.text)
                tags.append(tag_list)

            # Now I have in quotes, authors and tags the information I need
            # Ex. quotes[0] was written by authors[0] and its tags are tags[0]
            # (where tags is a list of lists)
            # TODO return results after summing them in between pages
            i+=1