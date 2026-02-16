import 'package:sortack/_tools.dart';

/// base filter criteria class
///
/// criterion = { key : value } entry
///
/// deep criterion = { key : { subkey : value } } entry
base class FilterCriteria<T extends Parameters> {
  final Map<T, Set> _criteria;

  FilterCriteria({Map<T, Set>? criterias}) : _criteria = criterias ?? {};

  bool isEmpty() => _criteria.isEmpty;
  bool isNotEmpty() => _criteria.isNotEmpty;

  Set criterion(T key) =>
      _criteria.containsKey(key) ? _criteria[key] ?? {} : {};
  bool selected(T key, dynamic value) => criterion(key).contains(value);

  void clear() => _criteria.clear;
  void replace(FilterCriteria<T> newFilter) {
    if (_criteria == newFilter._criteria) return;
    _criteria.clear();
    _criteria.addAll(newFilter._criteria);
  }

  void update(T key, dynamic value, bool selected) {
    if (_criteria.containsKey(key)) {
      if (selected)
        _criteria[key]?.add(value).toString();
      else
        _criteria[key]?.remove(value);
    } else {
      _criteria[key] = {value};
    }
  }

  bool matches(dynamic object) {
    for (final criterion in _criteria.entries) {
      final key = criterion.key;
      final set = criterion.value;
      final value = object.getParameter(key);
      if (!set.contains(value)) return false;
    }
    return true;
  }
}

/// sortable mixin
mixin Sortable<T, F extends Parameters> on Collector<T> {
  void sort({F by});
}

/// filterable mixin
mixin Filterable<T, F extends Parameters> on Collector<T> {
  final FilterCriteria filterCriterias = FilterCriteria();

  List<T> get filtered =>
      List<T>.of(collection.where((task) => filterCriterias.matches(task)));

  void filter(FilterCriteria<F> criteria) => filterCriterias.replace(criteria);
}
