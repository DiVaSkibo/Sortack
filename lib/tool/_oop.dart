import 'package:sortack/tool/_consts.dart';

class Task {
  final int id;
  String title;
  String? description;
  Status? status;
  PriorityLevel? priority;
  PointsTShirt? points;
  String? role;
  String? assignee;
  String? notes;

  Task({
    int? id,
    required this.title,
    this.description,
    this.status,
    this.priority,
    this.points,
    this.role,
    this.assignee,
    this.notes,
  }) : id = id ?? Random().nextInt(1000);

  int compareTo(Task b, {TaskParameters? by}) {
    dynamic avalue, bvalue;
    switch (by ?? TaskParameters.id) {
      case TaskParameters.id:
        avalue = id;
        bvalue = b.id;
        break;
      case TaskParameters.title:
        avalue = title;
        bvalue = b.title;
        break;
      case TaskParameters.description:
        avalue = description;
        bvalue = b.description;
        break;
      case TaskParameters.status:
        avalue = status;
        bvalue = b.status;
        break;
      case TaskParameters.priority:
        avalue = priority;
        bvalue = b.priority;
        break;
      case TaskParameters.points:
        avalue = points;
        bvalue = b.points;
        break;
      case TaskParameters.role:
        avalue = role;
        bvalue = b.role;
        break;
      case TaskParameters.assignee:
        avalue = assignee;
        bvalue = b.assignee;
        break;
      case TaskParameters.notes:
        avalue = notes;
        bvalue = b.notes;
        break;
    }
    if (avalue == null)
      return 0;
    else if (bvalue == null)
      return 1;
    return avalue.compareTo(bvalue);
  }

  bool testInterval<T extends Comparable>({
    required TaskParameters by,
    required T from,
    required T to,
  }) {
    dynamic value = switch (by) {
      TaskParameters.id => id,
      TaskParameters.title => title,
      TaskParameters.description => description,
      TaskParameters.status => status,
      TaskParameters.priority => priority,
      TaskParameters.points => points,
      TaskParameters.role => role,
      TaskParameters.assignee => assignee,
      TaskParameters.notes => notes,
    };
    if (value == null) return false;
    if (from == to) return value.compareTo(from) == 0;
    return from.compareTo(to) <= 0
        ? value.compareTo(from) >= 0 && value.compareTo(to) <= 0
        : value.compareTo(from) <= 0 || value.compareTo(to) >= 0;
  }

  @override
  String toString() =>
      '[$id]\n$title: $description\n $status ^$priority .$points\n @$role %$assignee\n$notes';
}
