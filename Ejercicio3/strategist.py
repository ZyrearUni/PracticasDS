from abc import ABC, abstractmethod

class strategist (ABC) :
    def __init__(self):
        self.page_total = 5

    @abstractmethod
    def scrapePage():
        pass
