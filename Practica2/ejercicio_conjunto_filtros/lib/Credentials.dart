class CredentialsManager {
  static final CredentialsManager _singleton = CredentialsManager._privateConstructor();
  Map<String, String> _creds = {'test1@gmail.com':'serv_pwd12', 'ejemplo2@hotmail.com':'word_1981'};

  factory CredentialsManager() {
    return _singleton;
  }

  CredentialsManager._privateConstructor() {
    /*
    // read from csv
    String s = _f.readAsStringSync();

    var lines = s.split('\n');
    for (int i = 0; i < lines.length; i++) {
      var split = lines[i].split(',');
      String? email = split[0];
      String? password = split[1];
      _creds[email] = password;
    }*/
  }

  void register(String email, String password) {
    //_f.writeAsStringSync('$email,$password',mode: FileMode.append);
    _creds[email] = password;
  }

  bool checkLogin(String email, String password) {
    if (_creds[email]==password) {
      return true;
    }
    return false;
  }

  bool checkAvailability(String email) {
    return _creds.containsKey(email);
  }


}
