import 'package:ejercicio_conjunto_filtros/Credentials.dart';
import 'package:ejercicio_conjunto_filtros/FormController.dart';
import 'package:ejercicio_conjunto_filtros/filters.dart';

class FilterList {
  List<Filter> filterList = [];
  //Target attribute missing

  void addFilter(Filter filter) {
    filterList.add(filter);
  }

  void execute(FormController credentials) {
    for (var filter in filterList) {
      if (credentials.valid) {
        filter.execute(credentials);
      }
    }

    if (credentials.valid) {
      CredentialsManager().register(credentials.email, credentials.password);
    }
  }
}