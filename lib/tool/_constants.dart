import 'package:flutter/material.dart';
import 'dart:math';
export 'package:flutter/material.dart';
export 'dart:math';

enum Status { toDo, inProgress, done }

enum PriorityLevel implements Comparable<PriorityLevel> {
  critical,
  very_high,
  high,
  medium,
  low,
  very_low;

  @override
  int compareTo(PriorityLevel other) => index - other.index;
}

enum PointsFibonacci implements Comparable<PointsFibonacci> {
  X0,
  X1,
  X2,
  X3,
  X5,
  X8,
  X13,
  X20,
  X40,
  X100;

  @override
  int compareTo(PointsFibonacci other) => index - other.index;
}

enum PointsTShirt implements Comparable<PointsTShirt> {
  XS,
  S,
  M,
  L,
  XL,
  XXL;

  @override
  int compareTo(PointsTShirt other) => index - other.index;
}

enum TaskParameters {
  id,
  title,
  description,
  status,
  priority,
  points,
  role,
  assignee,
  notes,
}

enum TaskFlowPurposes { create, edit }

const List<IconData> Unicons = [
  Icons.outlined_flag_rounded,
  Icons.auto_awesome_outlined,
  Icons.pets_rounded,
  Icons.flutter_dash_rounded,
  Icons.catching_pokemon_rounded,
  Icons.local_pizza_rounded,
  Icons.cake_rounded,
  Icons.rocket_launch_rounded,
  Icons.golf_course_rounded,
  Icons.bolt_rounded,
  Icons.whatshot_rounded,
  Icons.emoji_events_outlined,
  Icons.diamond_outlined,
];
IconData unicon() => Unicons[Random().nextInt(Unicons.length)];

int compareBetween(dynamic a, dynamic b, TaskParameters by) {
  dynamic avalue, bvalue;
  switch (by) {
    case TaskParameters.id:
      avalue = a.id;
      bvalue = b.id;
      break;
    case TaskParameters.title:
      avalue = a.title;
      bvalue = b.title;
      break;
    case TaskParameters.description:
      avalue = a.description;
      bvalue = b.description;
      break;
    case TaskParameters.status:
      avalue = a.status;
      bvalue = b.status;
      break;
    case TaskParameters.priority:
      avalue = a.priority;
      bvalue = b.priority;
      break;
    case TaskParameters.points:
      avalue = a.points;
      bvalue = b.points;
      break;
    case TaskParameters.role:
      avalue = a.role;
      bvalue = b.role;
      break;
    case TaskParameters.assignee:
      avalue = a.assignee;
      bvalue = b.assignee;
      break;
    case TaskParameters.notes:
      avalue = a.notes;
      bvalue = b.notes;
      break;
  }
  if (avalue == null)
    return 0;
  else if (bvalue == null)
    return 1;
  return avalue.compareTo(bvalue);
}

bool testInterval(dynamic x, TaskParameters by, dynamic from, dynamic to) {
  dynamic value = switch (by) {
    TaskParameters.id => x.id,
    TaskParameters.title => x.title,
    TaskParameters.description => x.description,
    TaskParameters.status => x.status,
    TaskParameters.priority => x.priority,
    TaskParameters.points => x.points,
    TaskParameters.role => x.role,
    TaskParameters.assignee => x.assignee,
    TaskParameters.notes => x.notes,
  };
  if (value == null) return false;
  if (from == to) return value.compareTo(from) == 0;
  return from.compareTo(to) <= 0
      ? value.compareTo(from) >= 0 && value.compareTo(to) <= 0
      : value.compareTo(from) <= 0 || value.compareTo(to) >= 0;
}
