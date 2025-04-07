class printer:
    def print(self,credentials):
        print('Email is ' + credentials.email)
        print('Password is ' + credentials.password)
        print('The credentials are ' + 'VALID' if credentials.valid else 'INVALID because of:\n' + '\n'.join(credentials.rejection_reason))

