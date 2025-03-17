from abc import ABC, abstractmethod

class Filter(ABC) :
    @abstractmethod
    def execute(self, credentials):
        pass

# TODO move every filter in a separate class
class BaseFilter(Filter):
    def execute(self, credentials):
        at_pos = credentials.email.find('@')
        if at_pos == -1 or at_pos == 0:
            credentials.valid = False
            return

        usable_mails = ['gmail.com','hotmail.com']
        if not credentials.email[1+at_pos:] in usable_mails:
            credentials.valid=False
            return


class PasswordLengthFilter(Filter): # length >= 8
    def execute(self,credentials):
        if len(credentials.password)<=7:
            credentials.valid = False
            return

class P4ssw0rdFilter(Filter):
    def execute(self,credentials):
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
class PasswordComplexityFilter(Filter):
    def execute(self,credentials):
        # check the password contains some special characters AND at least a number
        special = False
        number = False
        for l in credentials.password:
            if not l.isalnum(): # if not an alfanumeric char
                special = True
            if l.isnumeric():
                number = True
        if not special or not number:
            credentials.valid = False
            return

