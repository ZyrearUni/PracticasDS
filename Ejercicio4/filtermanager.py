from filterlist import FilterList
from filter import Filter

class FilterManager:
    def __init__(self,target):
        self.filterChain = FilterList()
        self.filterChain.setTarget(target)

    def add_filter(self,filter):
        self.filterChain.addFilter(filter)

    def execute_on(self,credentials):
        self.filterChain.execute(credentials)