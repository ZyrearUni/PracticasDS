import 'package:ejercicio_conjunto_filtros/Credentials.dart';
import 'package:ejercicio_conjunto_filtros/FilterList.dart';
import 'package:ejercicio_conjunto_filtros/FormController.dart';
import 'package:ejercicio_conjunto_filtros/filters.dart';

class FilterManager {
  FilterList filterChain = FilterList();

  void addFilter(Filter filter) {
    filterChain.addFilter(filter);
  }

  void executeOn(FormController credentials) {
    filterChain.execute(credentials);
  }

  void setTarget(CredentialsManager credentialsManager) {
    filterChain.setTarget(credentialsManager);
  }

}