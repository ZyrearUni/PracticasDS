from strategist import strategist, page_total
from bs4 import BeautifulSoup
import requests

class beautifulSoup (strategist):
    def __init__(self):
        super().__init__()

    # override
    def algorithmInterface():
        i = 1
        while i <= page_total:
            URL = "https://quotes.toscrape.com/page/" + i + "/"
            page = requests.get(URL)

            soup = beautifulSoup(page.content, "html.parser")


