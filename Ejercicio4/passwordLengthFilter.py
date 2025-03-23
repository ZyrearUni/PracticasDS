from Ejercicio4.filter import Filter


class PasswordLengthFilter(Filter):  # length >= 8
    def execute(self, credentials):
        if len(credentials.password) <= 7:
            credentials.reject('Password is too short')
            return
