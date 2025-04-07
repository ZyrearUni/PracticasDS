from Ejercicio4.filter import Filter


class PasswordComplexityFilter(Filter):
    def execute(self, credentials):
        # check the password contains some special characters AND at least a number
        special = False
        number = False
        for l in credentials.password:
            if not l.isalnum():  # if not an alfanumeric char
                special = True
            if l.isnumeric():
                number = True

        if not special and number:
            credentials.reject('The password requires at least one special character')
        elif special and not number:
            credentials.reject('The password requires at least one number')
        elif not special and not number:
            credentials.reject('The password requires at least one special character AND a number')

