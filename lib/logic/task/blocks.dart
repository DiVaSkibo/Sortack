import 'package:sortack/_tools.dart';

/// immutable task block interface class
@immutable
interface class Block with Parameterizable<TaskParameters> {
  final String id;
  String title;
  String description;
  TaskPriority priority;
  DateTime? deadline;
  String? assignee;

  Block({
    required this.id,
    this.title = '',
    this.description = '',
    this.priority = TaskPriority.medium,
    this.deadline,
    this.assignee,
  });

  @override
  dynamic getParameter(parameter, {comparable = false}) => switch (parameter) {
    TaskParameters.id => id,
    TaskParameters.title => title,
    TaskParameters.description => description,
    // TaskParameters.status => comparable ? status.index : status,
    TaskParameters.priority => comparable ? priority.index : priority,
    // TaskParameters.points =>
    //   comparable ? (points != null ? points!.index : -1) : points,
    // TaskParameters.role =>
    //   role, //comparable ? (role != null ? role!.index : -1) : role,
    TaskParameters.assignee => assignee,
    // TaskParameters.notes => notes,
    _ => null,
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
      '[$id]\n"$title": "$description"\n ^$priority\n %"$assignee"';
}

/// immutable advanced task block interface class
@immutable
interface class AdvancedBlock extends Block {
  TaskStatus status;
  TaskPointsTShirt? points;
  String? role;
  String notes;

  AdvancedBlock({
    required super.id,
    super.title = '',
    super.description = '',
    super.priority,
    super.deadline,
    super.assignee,
    this.status = TaskStatus.toDo,
    this.points,
    this.role,
    this.notes = '',
  });

  @override
  String toString() =>
      '[$id]\n"$title": "$description"\n $status ^$priority .$points\n @"$role" %"$assignee"\n"$notes"';
}
