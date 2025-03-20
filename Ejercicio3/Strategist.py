from abc import ABC, abstractmethod


class Strategist(ABC):
    def __init__(self):
        self.page_total = 5

    @abstractmethod
    def scrape_page(self):
        pass

    def process_into_dict(self, quotes, authors, tags):
        assert len(quotes) == len(authors) == len(tags)
        dictionary = {}
        for j in range(len(quotes)):  # str(tags[j])[1:-1] makes the list string and removes the []
            tags_str = str(tags[j])[1:-1].replace("'", '')
            dictionary[quotes[j]] = {'author': authors[j], 'tags': tags_str}

        return dictionary
