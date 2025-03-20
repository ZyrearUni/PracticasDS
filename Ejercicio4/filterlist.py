class FilterList:
    def __init__(self):
        self.filterList = []
        self.target = None
        
    def add_filter(self, filter):
        self.filterList.append(filter)

    def set_target(self, target):
        self.target = target

    def execute(self, credentials):
        for filter in self.filterList:
            filter.execute(credentials)
        if self.target is not None:
            self.target.print(credentials)
