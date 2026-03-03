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
