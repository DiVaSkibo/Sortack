import 'package:sortack/_tools.dart';

/// immutable task block interface class
@immutable
interface class Block with Parameterizable<TaskParameter> {
  final String id;
  bool enabled;
  String title;
  String description;
  PointsTShirt? points;
  DateTime? deadline;
  Set<String> assignee;

  Block({
    required this.id,
    this.enabled = true,
    this.title = '',
    this.description = '',
    this.points,
    this.deadline,
    Set<String>? assignee,
  }) : assignee = assignee ?? {};

  @override
  dynamic getParameter(parameter, {comparable = false}) => switch (parameter) {
    TaskParameter.id => id,
    TaskParameter.title => title,
    TaskParameter.description => description,
    // TaskParameter.status => comparable ? status.index : status,
    // TaskParameter.priority => comparable ? priority.index : priority,
    TaskParameter.points =>
      comparable ? (points != null ? points!.index : -1) : points,
    // TaskParameter.role =>
    //   role, //comparable ? (role != null ? role!.index : -1) : role,
    TaskParameter.assignee => assignee,
    // TaskParameter.notes => notes,
    _ => null,
  };

  bool testInterval<T extends Comparable>({
    required TaskParameter by,
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
      '[$id]\n"$title": "$description"\n .$points\n @"$assignee"';
}

/// immutable advanced task block interface class
@immutable
interface class AdvancedBlock extends Block {
  Status status;
  Priority priority;
  Set<Tag> tags;
  String notes;

  AdvancedBlock({
    required super.id,
    super.enabled = true,
    super.title = '',
    super.description = '',
    super.points,
    super.deadline,
    super.assignee,
    this.status = Status.toDo,
    this.priority = Priority.medium,
    Set<Tag>? tags,
    this.notes = '',
  }) : tags = tags ?? {};

  @override
  String toString() =>
      '[$id]\n"$title": "$description"\n $status ^$priority .$points\n %"$tags" @"$assignee"\n"$notes"';
}
