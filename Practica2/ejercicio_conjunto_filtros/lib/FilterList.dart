import 'dart:js_interop';

import 'package:ejercicio_conjunto_filtros/Credentials.dart';
import 'package:ejercicio_conjunto_filtros/FormController.dart';
import 'package:ejercicio_conjunto_filtros/filters.dart';

class FilterList {
  List<Filter> filterList = [];
  CredentialsManager? _credentialsManager;

  void addFilter(Filter filter) {
    filterList.add(filter);
  }

  void execute(FormController credentials) {
    for (var filter in filterList) {
      filter.execute(credentials);
    }
    if (credentials.valid) {
      if (_credentialsManager==null)
        throw NullRejectionException(false);
      _credentialsManager?.register(credentials.email, credentials.password);
    }
  }

  void setTarget(CredentialsManager credentialsManager) {
    this._credentialsManager = credentialsManager;
  }
}