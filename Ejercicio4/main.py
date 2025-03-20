from complexityFilter import PasswordComplexityFilter
from passwordLengthFilter import PasswordLengthFilter
from standardFilter import StandardFilter
from credentials import Credentials
from filtermanager import FilterManager
from printer import printer

if __name__ == '__main__':
    email = input('Type email: ')
    password = input('Type password: ')
    cr = Credentials(email, password)
    f_manager = FilterManager(printer())

    f_manager.add_filter(StandardFilter())
    f_manager.add_filter(PasswordLengthFilter())
    f_manager.add_filter(PasswordComplexityFilter())
    f_manager.add_filter(PasswordLengthFilter())

    f_manager.execute_on(cr)


