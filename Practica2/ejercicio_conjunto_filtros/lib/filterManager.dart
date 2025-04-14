import 'package:ejercicio_conjunto_filtros/FormController.dart';

import 'filters.dart';

class FilterChain {
  List<Filter> _filters = [];

    void addFilter(Filter f) {
    _filters.add(f);
  }

  void execute(FormController form) {
    for (Filter f in _filters) {
      f.execute(form);
    }
  }
}

class FilterManager {
  late FilterChain filterChain = FilterChain();

  void addFilter(Filter f) {
    filterChain.addFilter(f);
  }

  void executeOn(FormController form) {
    filterChain.execute(form);
  }
}