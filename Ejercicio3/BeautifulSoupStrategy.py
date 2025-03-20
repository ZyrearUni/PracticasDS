from strategist import strategist
from bs4 import BeautifulSoup
import requests


class BeautifulSoupStrategy(strategist):
    def __init__(self):
        super().__init__()

    def scrapePage(self):
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
                quotes.append(quote.text)

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

            assert len(quotes) == len(authors) == len(tags)

            # Now I have in quotes, authors and tags the information I need
            # Ex. quotes[0] was written by authors[0] and its tags are tags[0]
            # (where tags is a list of lists)
            return quotes, authors, tags
