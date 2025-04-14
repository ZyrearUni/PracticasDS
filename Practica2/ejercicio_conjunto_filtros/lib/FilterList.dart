import 'package:ejercicio_conjunto_filtros/FormController.dart';
import 'package:ejercicio_conjunto_filtros/filters.dart';

class FilterList {
  List<Filter> filterList = [];
  //Target attribute missing

  void addFilter(Filter filter) {
    filterList.add(filter);
  }

  //TODO: void setTarget

  void execute(FormController credentials) {
    for (var filter in filterList) {
      filter.execute(credentials);

    }

    //TODO: target logic
  }
}