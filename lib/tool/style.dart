import 'package:flutter/material.dart';
export 'package:flutter/material.dart';

/// static consts fonts class - custom static const fonts
final class Fonts {
  static const RUBIK = 'Rubik';
  static const RUBIK_ONE = 'Rubik One';
  static const RUBIK_MONO_ONE = 'Rubik Mono One';
  static const RUBIK_MARKER_HATCH = 'Rubik Marker Hatch';
}

/// static const colours class - custom static const colours
final class Colours {
  static const a = Color(0x00_000000);
  static const F = Color(0xFF_FFFFFF);
  static const O = Color(0xFF_000000);

  static const DRIVE = Color(0xFF_4DFFA6);
  static const DRIVE_UN = Color(0xFF_2CB26F);
  static const DRIVE_AC = Color(0xFF_00FF80);
  static const ANCHOR = Color(0xFF_80FFFF);
  static const ANCHOR_UN = Color(0xFF_1F9A9A);
  static const ANCHOR_AC = Color(0xFF_00FFFF);
  static const SHIFT = Color(0xFF_FFFF8C);
  static const SHIFT_UN = Color(0xFF_B2B262);
  static const SHIFT_AC = Color(0xFF_FFFF00);

  static const INK = Color(0xFF_089191);
  static const INK_UN = Color(0xFF_0F4C4C);
  static const INK_AC = Color(0xFF_B8E0E0);
  static const CANVAS = Color(0xFF_002424);
  static const CANVAS_UN = Color(0xFF_0B2626);
  static const CANVAS_AC = Color(0xFF_0A3333);

  static const GLOSS = Color(0x2F_00FFFF);
  static const SHADOW = Color(0xAF_001919);

  static const GOOD = Color(0xFF_66FF66);
  static const BAD = Color(0xFF_FF6666);

  static const OK = Color(0xFF_66FF7F);
  static const INOK = Color(0xFF_FFFF66);
  static const NOTOK = Color(0xFF_FF667F);

  static const CRITICAL = Color(0xFF_FF6666);
  static const VERY_HIGH = Color(0xFF_FFB266);
  static const HIGH = Color(0xFF_FFFF66);
  static const MEDIUM = Color(0xFF_66FFB2);
  static const LOW = Color(0xFF_66B2FF);
  static const VERY_LOW = Color(0xFF_6666FF);
  static const FROZEN = Color(0xFF_66FFFF);

  static const WARNING = Color(0xFF_6600FF);

  static const RAINBOW = [
    Colours.CRITICAL,
    Colours.VERY_HIGH,
    Colours.HIGH,
    Colours.MEDIUM,
    Colours.FROZEN,
    Colours.LOW,
    Colours.VERY_LOW,
  ];
  static const TRAFFIC = [Colours.NOTOK, Colours.INOK, Colours.OK];
  static const BINARY = [Colours.BAD, Colours.GOOD];
  static const STATIC = [Colours.F, Colours.O];
}

/// static const gradients class - custom static const gradients
final class Gradients {
  static const DECK = RadialGradient(
    center: Alignment.bottomCenter,
    radius: 1.0,
    colors: [Colours.CANVAS_AC, Colours.CANVAS_UN],
  );
  static const UPDECK = LinearGradient(
    begin: AlignmentGeometry.topCenter,
    end: AlignmentGeometry.bottomCenter,
    colors: [Colours.CANVAS_AC, Colours.CANVAS_UN],
  );
  static const PLANK = RadialGradient(
    center: Alignment.topLeft,
    radius: 1.5,
    colors: [Colours.CANVAS_AC, Colours.CANVAS],
  );
  static const SURFACE = RadialGradient(
    center: Alignment.centerRight,
    radius: 1.25,
    colors: [Colours.CANVAS_AC, Colours.CANVAS],
  );
  static const BLOCK = RadialGradient(
    center: Alignment.centerRight,
    radius: 5.0,
    colors: [Colours.CANVAS_AC, Colours.CANVAS],
  );
}

/// static const styles class - custom static const styles
final class Styles {
  static const TEXT = TextStyle(
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w500,
    color: Colours.F,
  );
  static const TEXT_UN = TextStyle(
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w500,
    color: Colours.O,
  );
  static const TEXT_OVER = TextStyle(
    fontSize: 20,
    fontFamily: Fonts.RUBIK_ONE,
    color: Colours.F,
  );
  static const TEXT_BUTTON_FILLED = TextStyle(
    fontSize: 15,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w700,
    color: Colours.O,
  );
  static const TEXT_INPUT = TextStyle(
    fontSize: 15,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w400,
    color: Colours.F,
  );
  static const TEXT_INPUT_DISABLED = TextStyle(
    fontSize: 15,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
    decorationThickness: 3,
    color: Colours.F,
  );
  static const TEXT_UNINPUT = TextStyle(
    fontSize: 17,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w600,
    color: Colours.CANVAS,
  );
  static const TEXT_INPUT_MULTILINE = TextStyle(
    fontSize: 14,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w300,
    color: Colours.F,
  );
  static const TEXT_UNINPUT_MULTILINE = TextStyle(
    height: 1.4,
    fontSize: 13,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w500,
    color: Colours.CANVAS_AC,
  );
  static const TEXT_INFO = TextStyle(
    fontSize: 13,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w500,
    color: Colours.INK_AC,
  );
  static const TEXT_UNINFO = TextStyle(
    fontSize: 13,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w600,
    color: Colours.CANVAS,
  );
  static const TEXT_INPUT_ITALIC = TextStyle(
    fontSize: 14,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    color: Colours.F,
  );

  static const BUTTON_LARGE = ButtonStyle(
    visualDensity: VisualDensity(vertical: -2.0),
    alignment: Alignment.center,
  );
}

/// static const decorations class - custom static const decorations
final class Decorations {
  static InputDecoration INPUT_FIELD({
    EdgeInsetsGeometry? padding,
    String? labelText,
    String? hintText,
    Color? hoverColor,
    Color? tipColor,
  }) => InputDecoration(
    floatingLabelAlignment: FloatingLabelAlignment.center,
    contentPadding:
        padding ?? EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
    filled: true,
    fillColor: Colours.a,
    hoverColor: hoverColor ?? Colours.SHADOW,
    labelText: labelText,
    hintText: hintText,
    labelStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: tipColor,
    ),
    hintStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: tipColor,
    ),
  );
}
