from strategist import strategist, page_total
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By

class selenium (strategist):
    def __init__(self):
        super().__init__()

    def algorithmInterface():
        driver = webdriver.Chrome()
        i = 1
        quotes = []
        while i <= page_total:
            URL = "https://quotes.toscrape.com/page/" + i + "/"
            driver.get(URL)

            quotes[i-1] = driver.find_elements(By.CLASS_NAME, "quote")

        driver.close()