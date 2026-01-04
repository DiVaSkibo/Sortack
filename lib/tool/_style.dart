import 'package:flutter/material.dart';

class Fonts {
  static const RUBIK = 'Rubik';
  static const RUBIK_ONE = 'Rubik One';
  static const RUBIK_MONO_ONE = 'Rubik Mono One';
}

class Colours {
  static const o = Colors.transparent;
  static const W = Color(0xFF_FFFFFF);
  static const B = Color(0xFF_000000);

  static const TOP = Color(0xFF_4DFFA6);
  static const CENTER = Color(0xFF_FFFF8C);
  static const BOTTOM = Color(0xFF_80FFFF);
  static const ACTOP = Color(0xFF_00FF80);
  static const ACCENTER = Color(0xFF_FFFF00);
  static const ACBOTTOM = Color(0xFF_00FFFF);
  static const UNTOP = Color(0xFF_2CB26F);
  static const UNCENTER = Color(0xFF_B2B262);
  static const UNBOTTOM = Color(0xFF_1F9A9A);

  static const FRONT = Color(0xFF_0B7373);
  static const BACK = Color(0xFF_002424);
  static const UNFRONT = Color(0xFF_0F4C4C);
  static const UNBACK = Color(0xFF_0B2626);
  static const BACK_GLOW = Color(0xFF_0A3333);

  static const GLOSS = Color(0x2F_00FFFF);
  static const TINGE = Color(0x8F_001919);
  static const SHADOW = Color(0xAF_001919);

  static const OK = Color(0xFF_66FF7F);
  static const INOK = Color(0xFF_FFFF66);
  static const NOTOK = Color(0xFF_FF667F);
  static const WARNING = Color(0xFF_6600FF);
}

class Gradients {
  static const GROUND = RadialGradient(
    center: Alignment.bottomCenter,
    radius: 1.0,
    colors: [Colours.BACK_GLOW, Colours.UNBACK],
  );
  static const SURFACE = RadialGradient(
    center: Alignment.topLeft,
    radius: 1.5,
    colors: [Colours.BACK_GLOW, Colours.BACK],
  );
}
