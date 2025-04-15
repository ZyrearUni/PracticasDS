import 'package:ejercicio_conjunto_filtros/FilterList.dart';
import 'package:ejercicio_conjunto_filtros/FormController.dart';
import 'package:ejercicio_conjunto_filtros/filters.dart';

class FilterManager {
  FilterList filterChain = FilterList();

  void addFilter(Filter filter) {
    filterChain.addFilter(filter);
    //TODO: target logic
  }

  void executeOn(FormController credentials) {
    filterChain.execute(credentials);
  }
}