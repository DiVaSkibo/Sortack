import 'package:flutter/material.dart';
import 'dart:math';
export 'package:flutter/material.dart';

enum PointsFibonacci { X0, X1, X2, X3, X5, X8, X13, X20, X40, X100 }

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

enum TaskParameters { id, name, points, status, role, assignee }

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
  switch (by) {
    case TaskParameters.id:
      return a.hashCode.compareTo(b.hashCode);
    case TaskParameters.name:
      return a.name.compareTo(b.name);
    case TaskParameters.points:
      if (a.points == null)
        return 0;
      else if (b.points == null)
        return 1;
      return a.points!.index.compareTo(b.points!.index);
    case TaskParameters.status:
      return a.status.compareTo(b.status);
    case TaskParameters.role:
      if (a.role == null)
        return 0;
      else if (b.role == null)
        return 1;
      return a.role!.index.compareTo(b.role!.index);
    case TaskParameters.assignee:
      if (a.assignee == null)
        return 0;
      else if (b.assignee == null)
        return 1;
      return a.assignee!.index.compareTo(b.assignee!.index);
  }
}

bool testInterval(dynamic x, TaskParameters by, dynamic from, dynamic to) {
  dynamic value = switch (by) {
    TaskParameters.id => x.hashCode,
    TaskParameters.name => x.name,
    TaskParameters.points => x.points,
    TaskParameters.status => x.status,
    TaskParameters.role => x.role,
    TaskParameters.assignee => x.assignee,
  };
  if (value == null) return false;
  if (from == to) return value.compareTo(from) == 0;
  return from.compareTo(to) <= 0
      ? value.compareTo(from) >= 0 && value.compareTo(to) <= 0
      : value.compareTo(from) <= 0 || value.compareTo(to) >= 0;
}
