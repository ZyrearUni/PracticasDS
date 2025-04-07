from filterlist import FilterList


class FilterManager:
    def __init__(self, target):
        self.filterChain = FilterList()
        self.filterChain.set_target(target)

    def add_filter(self, filter):
        self.filterChain.add_filter(filter)

    def execute_on(self, credentials):
        self.filterChain.execute(credentials)
