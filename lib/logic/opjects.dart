import 'package:sortack/_tools.dart';

base class FilterCriteria<T extends Parameters> {
  final Map<T, dynamic> _criteria;

  FilterCriteria({Map<T, dynamic>? criterias}) : _criteria = criterias ?? {};

  bool isEmpty() => _criteria.isEmpty;
  bool isNotEmpty() => _criteria.isNotEmpty;

  void clear() => _criteria.clear;
  void update(T key, dynamic value) {
    if (value == null)
      _criteria.remove(key);
    else
      _criteria[key] = value;
  }

  bool matches(dynamic object) {
    for (final criterion in _criteria.entries) {
      final key = criterion.key;
      final value = criterion.value;
      final parameter = object.getParameter(key);
      if (value is FromTo) if (value.check(parameter)) return false;
      if (parameter != value) return false;
    }
    return true;
  }
}

mixin Sortable<T extends Parameterizable, F extends Parameters>
    on Collector<T> {
  void sort({F by});
}
mixin Filterable<T extends Parameterizable, F extends Parameters>
    on Collector<T> {
  final FilterCriteria filterCriterias = FilterCriteria();

  List<T> filter() =>
      List<T>.of(collection.where((task) => filterCriterias.matches(task)));

  void updateFilterCriterion({required F parameter, dynamic criterion}) =>
      filterCriterias.update(parameter, criterion);
}
