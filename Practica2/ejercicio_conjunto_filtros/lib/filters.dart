import 'package:ejercicio_conjunto_filtros/FormController.dart';

abstract class Filter {
  void execute(FormController credentials);
}

class StandardFilter extends Filter {
  final List<String> USABLE_EMAILS = ["gmail.com", "hotmail.com"];

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

class NewEmailFilter extends Filter {
  static List<String> registered_emails = ["test1@gmail.com"];

  void execute(FormController credentials) {
    bool found = false;

    for (int i = 0; i < registered_emails.length && !found; i++) {
      found = credentials.email == registered_emails[i];
    }

    if (found) {
      credentials.rejectEmail("is already registered in the system");
    }
  }
}

class PasswordLengthFilter extends Filter {
  final int MIN_LENGTH = 7;
  void execute(FormController credentials) {
    if (credentials.password.length < MIN_LENGTH) {
      credentials.rejectPassword("is not long enough");
    }
  }
}

class P4ssw0rdFilter extends Filter {
  void execute(FormController credentials) {
    //TODO
  }
}

class PasswordComplexityFilter extends Filter {
  void execute(FormController credentials) {
    //TODO
  }
}