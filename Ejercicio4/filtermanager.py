from filterlist import FilterList
from filter import Filter

class FilterManager:
    def __init__(self):
        self.filterChain = FilterList()

    def addFilter(filter):
        self.filterChain.addFilter(filter)