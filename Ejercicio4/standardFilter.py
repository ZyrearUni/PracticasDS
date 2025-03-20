from Ejercicio4.filter import Filter

class StandardFilter(Filter):
    def execute(self, credentials):
        at_pos = credentials.email.find('@')
        if at_pos == -1 or at_pos == 0:
            credentials.valid = False
            return

        usable_mails = ['gmail.com','hotmail.com']
        if not credentials.email[1+at_pos:] in usable_mails:
            credentials.valid=False
            return
