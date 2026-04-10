import 'package:sortack/_tools.dart';

/// immutable task block interface class
@immutable
interface class Block with Parameterizable<TaskParameters> {
  final String id;
  String title;
  String description;
  PointsTShirt? points;
  DateTime? deadline;
  List<String> assignee;

  Block({
    required this.id,
    this.title = '',
    this.description = '',
    this.points,
    this.deadline,
    List<String>? assignee,
  }) : assignee = assignee ?? [];

  @override
  dynamic getParameter(parameter, {comparable = false}) => switch (parameter) {
    TaskParameters.id => id,
    TaskParameters.title => title,
    TaskParameters.description => description,
    // TaskParameters.status => comparable ? status.index : status,
    // TaskParameters.priority => comparable ? priority.index : priority,
    TaskParameters.points =>
      comparable ? (points != null ? points!.index : -1) : points,
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
      '[$id]\n"$title": "$description"\n .$points\n @"$assignee"';
}

/// immutable advanced task block interface class
@immutable
interface class AdvancedBlock extends Block {
  Status status;
  Priority priority;
  List<Tag> tags;
  String notes;

  AdvancedBlock({
    required super.id,
    super.title = '',
    super.description = '',
    super.points,
    super.deadline,
    super.assignee,
    this.status = Status.toDo,
    this.priority = Priority.medium,
    List<Tag>? tags,
    this.notes = '',
  }) : tags = tags ?? [];

  @override
  String toString() =>
      '[$id]\n"$title": "$description"\n $status ^$priority .$points\n %"$tags" @"$assignee"\n"$notes"';
}
