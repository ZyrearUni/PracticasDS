from strategist import strategist

from selenium import webdriver

from selenium.webdriver.common.by import By


class SeleniumStrategy(strategist):
    def __init__(self):
        super().__init__()

    def scrapePage(self):
        driver = webdriver.Firefox()

        quotes = []
        authors = []
        tags = []
        for i in range(1, self.page_total + 1):
            URL = "https://quotes.toscrape.com/page/" + str(i)
            driver.get(URL)

            # SELENIUM SEARCH BY XPath
            res_quotes = driver.find_elements(By.XPATH, "//div[@class='quote']/span[@class='text']")
            for quote in res_quotes:
                quotes.append(quote.text)
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

        driver.close()
        assert len(quotes) == len(authors) == len(tags)

        # Now I have in quotes, authors and tags the information I need
        # Ex. quotes[0] was written by authors[0] and its tags are tags[0]
        # (where tags is a list of lists)
        return quotes, authors, tags

if __name__ == "__main__":
    SeleniumStrategy().scrapePage()
