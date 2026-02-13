import 'package:sortack/_tools.dart';

/// immutable task block class
@immutable
class TaskBlock with Parameterizable<TaskParameters> {
  final int id;
  String title;
  String description;
  TaskStatus status;
  TaskPriority? priority;
  TaskPointsTShirt? points;
  String? role;
  String? assignee;
  String notes;

  TaskBlock({
    int? id,
    this.title = '',
    this.description = '',
    this.status = TaskStatus.toDo,
    this.priority,
    this.points,
    this.role,
    this.assignee,
    this.notes = '',
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  @override
  dynamic getParameter(parameter, {comparable = false}) => switch (parameter) {
    TaskParameters.id => id,
    TaskParameters.title => title,
    TaskParameters.description => description,
    TaskParameters.status => comparable ? status.index : status,
    TaskParameters.priority =>
      comparable ? (priority != null ? priority!.index : -1) : priority,
    TaskParameters.points =>
      comparable ? (points != null ? points!.index : -1) : points,
    TaskParameters.role =>
      role, //comparable ? (role != null ? role!.index : -1) : role,
    TaskParameters.assignee => assignee,
    TaskParameters.notes => notes,
  };

  bool testInterval<T extends Comparable>({
    required TaskParameters by,
    required T from,
    required T to,
  }) {
    dynamic value = getParameter(by);
    if (value == null) return false;
    if (from == to) return value.compareTo(from) == 0;
    return from.compareTo(to) <= 0
        ? value.compareTo(from) >= 0 && value.compareTo(to) <= 0
        : value.compareTo(from) <= 0 || value.compareTo(to) >= 0;
  }

  @override
  String toString() =>
      '[$id]\n"$title": "$description"\n $status ^$priority .$points\n @"$role" %"$assignee"\n"$notes"';
}

/// task block controller - control task block parameters
class TaskBlockController extends ChangeNotifier {
  final TaskBlock _task;
  TaskBlock get task => _task;

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController notesController;
  final FocusNode titleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode notesFocus = FocusNode();

  TaskBlockController(this._task) {
    _initializeControllers();
    _setupFocusListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    titleFocus.dispose();
    descriptionFocus.dispose();
    notesFocus.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    titleController = TextEditingController(text: _task.title);
    descriptionController = TextEditingController(text: _task.description);
    notesController = TextEditingController(text: _task.notes);
  }

  void _setupFocusListeners() {
    titleFocus.addListener(() {
      if (!titleFocus.hasFocus && titleController.text != _task.title) {
        _task.title = titleController.text;
        notifyListeners();
      }
    });
    descriptionFocus.addListener(() {
      if (!descriptionFocus.hasFocus &&
          descriptionController.text != _task.description) {
        _task.description = descriptionController.text;
        notifyListeners();
      }
    });
    notesFocus.addListener(() {
      if (!notesFocus.hasFocus && notesController.text != _task.notes) {
        _task.notes = notesController.text;
        notifyListeners();
      }
    });
  }

  void updateStatus(TaskStatus status) {
    if (_task.status == status) return;
    _task.status = status;
    notifyListeners();
  }

  void updatePriority(TaskPriority priority) {
    if (_task.priority == priority) return;
    _task.priority = priority;
    notifyListeners();
  }

  void updatePoints(TaskPointsTShirt points) {
    if (_task.points == points) return;
    _task.points = points;
    notifyListeners();
  }
}
