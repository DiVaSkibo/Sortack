import 'package:flutter/material.dart';

class Fonts {
  static const RUBIK = 'Rubik';
  static const RUBIK_ONE = 'Rubik One';
  static const RUBIK_MONO_ONE = 'Rubik Mono One';
}

class Colours {
  static const LIGHT = Color(0xFF_FFFFFF);
  static const DARK = Color(0xFF_000000);
  static const ACCENT = Color(0xFF_00FFFF);
  static const INACCENT = Color(0xFF_80FFFF);
  static const UNACCENT = Color(0xFF_8FCCCC);
  static const GLOSS = Color(0x2F_00FFFF);
  static const TINGE = Color(0x8F_001919);
  static const SHADOW = Color(0xAF_001919);
  static const OK = Color(0xFF_66FF7F);
  static const INOK = Color(0xFF_FFFF66);
  static const NOTOK = Color(0xFF_FF667F);
  static const FRONT = Color(0xFF_0B7373);
  static const UNFRONT = Color(0xFF_0F4C4C);
  static const BACK = Color(0xFF_002424);
  static const UNBACK = Color(0xFF_0B2626);
  static const BACK_GLOW = Color(0xFF_0A3333);
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
