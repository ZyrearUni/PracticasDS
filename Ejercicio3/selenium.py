from strategist import strategist, page_total
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By

class selenium (strategist):
    def __init__(self):
        super().__init__()

    def scrapePage():
        driver = webdriver.Firefox()
        i = 1
        quotes = []
        while i <= page_total:
            URL = "https://quotes.toscrape.com/page/" + str(i)
            driver.get(URL)

            quotes_list = driver.find_elements(By.CLASS_NAME, "quote")
            for s in range(len(quotes_list)):
                quotes.append(quotes_list[s].text)
            
            i=i+1

        driver.close()

        # Aquí ya habría que sacar la información directamente de quotes, ya que ya tiene las frases, los autores y los tags guardados
