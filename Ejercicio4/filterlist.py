
class FilterList:
    def __init__(self):
        # It's created by the filter manager
        self.filterList = []
        self.target = None
        
    def addFilter(self,filter):
        self.filterList.append(filter)

    def setTarget(self,target):
        self.target = target

    def execute(self,credentials):
        for filter in self.filterList:
            filter.execute(credentials)
        if self.target is not None:
            (self.target).print(credentials)
