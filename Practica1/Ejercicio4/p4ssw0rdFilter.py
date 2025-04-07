from Ejercicio4.filter import Filter


class P4ssw0rdFilter(Filter):
    def execute(self, credentials):
        # check if password starts with something like p4assw0rd

        letter_number_association = {'a': '4', 's': '5', 'e': '3', 'o': '0'}
        pwd = credentials.password.lower()

        password_len = len('password')
        for j in range(len(pwd)-password_len+1):  # attempt once for every possible starting letter
            check = True
            for i in range(password_len):
                # for each letter check if it is letter in "password" or its number substitution
                if pwd[j+i] != 'password'[i]:
                    # if on two lines to improve readability
                    if 'password'[i] not in letter_number_association or pwd[j+i] != letter_number_association['password'[i]]:
                        check = False
                        break

            if check:
                credentials.reject('The password cannot contain password (accounting with classic number-letter substitutions)')
