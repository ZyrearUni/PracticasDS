from Ejercicio4.filter import Filter


class P4ssw0rdFilter(Filter):
    def execute(self, credentials):
        # check if password starts with something like p4assw0rd

        letter_number_association = {'a': '4', 's': '5', 'e': '3', 'o': '0'}
        pwd = credentials.password.lower()
        check = True
        for i in range(8):
            # for each letter check if its the letter in password or its number substitution
            if not pwd[i] == 'password'[i] and not pwd[i] == letter_number_association['password'[i]]:
                check = False
        if check:
            credentials.valid = False
            return
