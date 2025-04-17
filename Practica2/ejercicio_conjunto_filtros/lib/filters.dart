import 'package:ejercicio_conjunto_filtros/Credentials.dart';
import 'package:ejercicio_conjunto_filtros/FormController.dart';

abstract class Filter {
  void execute(FormController credentials);
}

class StandardFilter extends Filter {
  final List<String> USABLE_EMAILS = ["gmail.com", "hotmail.com"];

  @override
  void execute(FormController credentials) {
    int pos = credentials.email.indexOf("@");
    if (pos == -1 || pos == 0) {
      credentials.rejectEmail("does not contain @ or is in an invalid position");
    }
    else {
      bool found = false;
      for (int i = 0; i < USABLE_EMAILS.length && !found; i++) {
        found = credentials.email.contains(USABLE_EMAILS[i], pos);
      }
      if (!found) {
        credentials.rejectEmail("is not registered to a known website");
      }
    }
  }
}

//Recomendable añadir este filtro el último de las comprobaciones de correo
class NewEmailFilter extends Filter {

  final CredentialsManager _credentialsManager;
  NewEmailFilter(this._credentialsManager);

  @override
  void execute(FormController credentials) {
    if (credentials.valid) {
      bool found = _credentialsManager.checkAvailability(credentials.email);

      if (found) {
        credentials.rejectEmail("is already registered in the system");
      }
    }
  }
}

class PasswordLengthFilter extends Filter {
  final int MIN_LENGTH = 7;
  @override
  void execute(FormController credentials) {
    if (credentials.password.length < MIN_LENGTH) {
      credentials.rejectPassword("is not long enough");
    }
  }
}

class PasswordComplexityFilter extends Filter {
  @override
  void execute(FormController credentials) {
    String check = credentials.password;
    bool containsCaps = check.contains(RegExp(r'[A-Z]'));
    bool containsLower = check.contains(RegExp(r'[a-z]'));
    bool containsNumber = check.contains(RegExp(r'[0-9]'));
    //bool containsSpecial = check.contains(RegExp(r'[-_&@]')); (Optional)

    if (!containsLower) {
      credentials.rejectPassword("does not contain lowercase characters");
    }
    if (!containsCaps) {
      String t = !containsLower ?
      "uppercase characters": "does not contain uppercase characters";
      credentials.rejectPassword(t);
    }
    if (!containsNumber) {
      String t = !containsLower || !containsCaps ?
      "numbers": "does not contain numbers characters";
      credentials.rejectPassword(t);
    }
  }
}

class P4ssw0rdFilter extends Filter {
  @override
  void execute(FormController credentials) {
    String passwd = credentials.password.toLowerCase();
    passwd = passwd.replaceAll("4", "a");
    passwd = passwd.replaceAll("5", "s");
    passwd = passwd.replaceAll("3", "e");
    passwd = passwd.replaceAll("0", "o");

    bool contains = false;
    int lenPwd = 'password'.length;
    for (int i=0; i<passwd.length-lenPwd+1; i++) {
      String word = passwd.substring(i,i+lenPwd);
      if (word=='password') {
        contains = true;
      }
    }
    if (contains) {
      credentials.rejectPassword("cannot be a variation of 'password'");
    }
  }
}

