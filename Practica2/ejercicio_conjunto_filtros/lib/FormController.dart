


class FormController {
  String email;
  String password;

  String? _emailReason;
  String? _passwordReason;
  bool _valid = true;

  FormController(this.email, this.password);

  void rejectEmail(String reason) {
    _valid = false;
    if (_emailReason==null) {
      _emailReason = 'The email $reason';
    } else {
      _emailReason = '${_emailReason!} and $reason';
    }
  }

  void rejectPassword(String reason) {
    _valid = false;
    if (_passwordReason==null) {
      _passwordReason = 'The password $reason';
    } else {
      _passwordReason = '${_passwordReason!} and $reason';
    }
  }

  String toString() {
   return 'email: $email is ${emailReason==null?'valid':'not valid because of $emailReason'} \n '
       'password: $password is ${passwordReason==null?'valid':'not valid because of $passwordReason'} \n';
  }

  bool get valid => _valid;

  get passwordReason => _passwordReason;

  get emailReason => _emailReason;
}