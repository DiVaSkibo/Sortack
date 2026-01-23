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
  notes;

  IconData icon() => [
    Icons.numbers_rounded,
    Icons.title_rounded,
    Icons.text_fields_rounded,
    Icons.air_rounded,
    Icons.priority_high_rounded,
    Icons.adjust_rounded,
    Icons.work_rounded,
    Icons.accessibility_rounded,
    Icons.comment_rounded,
  ][index];
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
