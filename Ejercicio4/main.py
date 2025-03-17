from credentials import credentials
from filtermanager import FilterManager
from printer import printer
from filter import *


if __name__=='__main__':
    email = input('Type email: ')
    password = input('Type password: ')
    cr = credentials(email, password)
    f_manager = FilterManager(printer())

    f_manager.add_filter(BaseFilter())
    f_manager.add_filter(PasswordLengthFilter())
    f_manager.add_filter(PasswordComplexityFilter())
    f_manager.add_filter(PasswordLengthFilter())

    f_manager.execute_on(cr)


