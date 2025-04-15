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

//Recomendable añadir este filtro el último
class NewEmailFilter extends Filter {

  @override
  void execute(FormController credentials) {
    bool found = CredentialsManager().checkAvailability(credentials.email);

    if (found) {
      credentials.rejectEmail("is already registered in the system");
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

class P4ssw0rdFilter extends Filter {
  @override
  void execute(FormController credentials) {
    //TODO
  }
}

class PasswordComplexityFilter extends Filter {
  @override
  void execute(FormController credentials) {
    //TODO
  }
}