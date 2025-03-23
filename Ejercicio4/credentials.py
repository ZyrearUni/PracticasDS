class Credentials:
    def __init__(self, email, password):
        self.email = email
        self.password = password
        self.valid = True
        self.rejection_reason = None

    def get_email(self):
        return self.email

    def get_password(self):
        return self.password

    def set_password(self, password):
        self.password = password

    def set_email(self, email):
        self.email = email

    def reject(self,reason):
        if self.rejection_reason is None:
            self.rejection_reason = []
        self.rejection_reason.append(reason)
        self.valid = False