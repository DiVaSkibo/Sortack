import 'package:sortack/_tools.dart';

final class ColoredTitleController extends ChangeNotifier {
  String _title;
  Color _color;
  String get title => _title;
  Color get color => _color;

  late final TextEditingController titleController;
  final FocusNode titleFocus = FocusNode();

  ColoredTitleController({String? initialTitle, Color? initialColor})
    : _title = initialTitle ?? '',
      _color = initialColor ?? Colours.BOTTOM {
    _initializeControllers();
    _setupFocusListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    titleFocus.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    titleController = TextEditingController(text: _title);
  }

  void _setupFocusListeners() {
    titleFocus.addListener(() {
      if (!titleFocus.hasFocus && titleController.text != _title) {
        _title = titleController.text;
        notifyListeners();
      }
    });
  }

  void updateColor(Color value) {
    if (_color == value) return;
    _color = value;
    notifyListeners();
  }
}

/// base filter criteria class
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

/// sortable mixin
mixin Sortable<T extends Parameterizable, F extends Parameters>
    on Collector<T> {
  void sort({F by});
}

/// filterable mixin
mixin Filterable<T extends Parameterizable, F extends Parameters>
    on Collector<T> {
  final FilterCriteria filterCriterias = FilterCriteria();

  List<T> filter() =>
      List<T>.of(collection.where((task) => filterCriterias.matches(task)));

  void updateFilterCriterion({required F parameter, dynamic criterion}) =>
      filterCriterias.update(parameter, criterion);
}
