class CredentialsManager {

  Map<String, String> _creds = {};

  CredentialsManager([Map<String, String>? credentials])  {
    if (credentials!=null) {
      _creds = credentials;
  }

  //CredentialsManager () {
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
