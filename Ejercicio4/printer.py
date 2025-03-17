class printer:
    def print(self,credentials):
        print('Email is ' + credentials.email)
        print('Password is ' + credentials.password)
        print('The password is ' + 'VALID' if credentials.valid else 'INVALID')
