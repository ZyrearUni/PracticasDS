from Strategist import Strategist

from selenium import webdriver

from selenium.webdriver.common.by import By


class SeleniumStrategy(Strategist):
    def __init__(self, page_total):
        super().__init__(page_total)

    def scrape_page(self):
        driver = webdriver.Firefox()

        quotes = []
        authors = []
        tags = []

        URL = "https://quotes.toscrape.com/page/1"
        driver.get(URL)

        for i in range(1, self.page_total + 1):
            # SELENIUM SEARCH BY XPath
            res_quotes = driver.find_elements(By.XPATH, "//div[@class='quote']/span[@class='text']")
            for quote in res_quotes:
                quotes.append(quote.text[1:-1])  # [1:-1] used to remove " "  (unicode characters)
                # print(quote.get_attribute('innerHTML'))

            res_authors = driver.find_elements(By.XPATH, "//div[@class='quote']/span/small[@class='author']")

            for author in res_authors:
                authors.append(author.text)

            res_tags = driver.find_elements(By.XPATH, "//div[@class='quote']/div[@class='tags']")

            for r_tag_list in res_tags:
                tags_per_quote = r_tag_list.find_elements(By.XPATH, ".//a[@class='tag']")
                tag_list = []
                for t in tags_per_quote:
                    tag_list.append(t.text)

                tags.append(tag_list)

            # click on next instead of going directly to URL as a basic measure to avoid being detected
            # as a scrapper, although toscrape.com allows scraping and in this case we won't need it
            if i != self.page_total:
                next_button = driver.find_element(By.XPATH, "//nav/ul[@class='pager']//li[@class='next']/a")
                driver.execute_script("arguments[0].scrollIntoView();", next_button)
                next_button.click()
        driver.close()
        assert len(quotes) == len(authors) == len(tags)

        # Now I have in quotes, authors and tags the information I need
        # Ex. quotes[0] was written by authors[0] and its tags are tags[0]
        # (where tags is a list of lists)

        # in case of a bigger scrapping it would be safer to store data to file while scrapping, to avoid
        # loosing data in case of error, but being a simple example we did it in main to keep the class
        # system more structured

        dictionary = self.process_into_dict(quotes, authors, tags)

        return dictionary
