import 'package:sortack/_tools.dart';

base class FilterCriterias<T extends Parameters> {
  final Map<T, dynamic> _criterias;

  const FilterCriterias({Map<T, dynamic>? criterias})
    : _criterias = criterias ?? const {};

  bool isEmpty() => _criterias.isEmpty;
  bool isNotEmpty() => _criterias.isNotEmpty;

  void clear() => _criterias.clear;
  void update(T key, dynamic value) => _criterias[key] = value;

  bool matches(dynamic object) {
    for (final criteria in _criterias.entries) {
      if (object.getParameter(criteria.key) == criteria.value) return false;
    }
    return true;
  }
}

mixin Sortable<T, F extends Parameters> on Collector<T> {
  void sort({F by});
}
mixin Filterable<T, F extends Parameters> on Collector<T> {
  final FilterCriterias filterCriterias = FilterCriterias();

  List<T> filter() =>
      List<T>.of(collection.where((task) => filterCriterias.matches(task)));

  void updateFilterCreteria({required F by, dynamic from, dynamic to}) =>
      filterCriterias.update(by, [from, to]);
}
