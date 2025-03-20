from abc import ABC, abstractmethod


class Strategist(ABC):
    def __init__(self, page_total):
        self.page_total = page_total

    @abstractmethod
    def scrape_page(self):
        pass

    def process_into_dict(self, quotes, authors, tags):
        assert len(quotes) == len(authors) == len(tags)
        dictionary = {}
        for j in range(len(quotes)):  # str(tags[j])[1:-1] makes the list string and removes the []
            tags_str = str(tags[j])[1:-1].replace("'", '')
            tags_str = tags_str.replace('\n', '')
            dictionary[quotes[j]] = {'author': authors[j], 'tags': tags_str}

        return dictionary
