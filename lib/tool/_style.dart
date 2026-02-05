import 'package:flutter/material.dart';
export 'package:flutter/material.dart';

/// fonts static const class - custom static const fonts
class Fonts {
  static const RUBIK = 'Rubik';
  static const RUBIK_ONE = 'Rubik One';
  static const RUBIK_MONO_ONE = 'Rubik Mono One';
}

/// colours static const class - custom static const colours
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

/// gradients static const class - custom static const gradients
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

/// styles static const class - custom static const styles
class Styles {
  static const LARGE_TEXT = TextStyle(
    fontFamily: Fonts.RUBIK_MONO_ONE,
    fontSize: 60,
  );
  static TextStyle columnText({Color? color}) =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color);
  static const TASK_TITLE_TEXT = TextStyle(
    fontSize: 17,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w600,
    color: Colours.BACK,
  );
  static const TASK_DESCRIPTION_TEXT = TextStyle(
    height: 1.4,
    fontSize: 13,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w500,
    color: Colours.BACK_GLOW,
  );
  static const TASK_NOTES_TEXT = TextStyle(
    height: 1.4,
    fontSize: 11,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    color: Colours.FRONT,
  );
  static TextStyle cardLabelText({double? fontSize, FontWeight? fontWeight}) =>
      TextStyle(
        fontSize: fontSize ?? 13,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: Colours.UNTOP,
      );
  static TextStyle cardHintText({double? fontSize, FontWeight? fontWeight}) =>
      TextStyle(
        fontSize: fontSize ?? 15,
        fontWeight: fontWeight ?? FontWeight.w600,
        fontStyle: FontStyle.italic,
        color: Colours.UNTOP,
      );
}

/// decorations static const class - custom static const decorations
class Decorations {
  static const GROUND_BOX = BoxDecoration(gradient: Gradients.GROUND);
  static final SURFACE_BOX = BoxDecoration(
    gradient: Gradients.SURFACE,
    borderRadius: BorderRadius.circular(15),
  );
  static InputDecoration cardInput({
    required bool collapsed,
    String? labelText,
    String? hintText,
  }) => InputDecoration(
    contentPadding: collapsed
        ? EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0)
        : EdgeInsets.fromLTRB(20.0, 12.0, 10.0, 18.0),
    filled: true,
    fillColor: Colours.o,
    hoverColor: Colours.CENTER,
    labelText: labelText,
    labelStyle: Styles.cardLabelText(),
    hintText: hintText,
    hintStyle: Styles.cardHintText(),
    floatingLabelAlignment: FloatingLabelAlignment.center,
  );
}
