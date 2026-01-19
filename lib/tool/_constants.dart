import 'package:flutter/material.dart';
import 'dart:math';

export 'package:flutter/material.dart';

enum PointsFibonacci { X0, X1, X2, X3, X5, X8, X13, X20, X40, X100 }

enum PointsTShirt { XS, S, M, L, XL, XXL }

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
