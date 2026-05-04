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
  static const STATIC = [Colours.W, Colours.B];
}

/// static const gradients class - custom static const gradients
final class Gradients {
  static const DECK = RadialGradient(
    center: Alignment.bottomCenter,
    radius: 1.0,
    colors: [Colours.BACK_GLOW, Colours.UNBACK],
  );
  static const UPDECK = LinearGradient(
    begin: AlignmentGeometry.topCenter,
    end: AlignmentGeometry.bottomCenter,
    colors: [Colours.BACK_GLOW, Colours.UNBACK],
  );
  static const PLANK = RadialGradient(
    center: Alignment.topLeft,
    radius: 1.5,
    colors: [Colours.BACK_GLOW, Colours.BACK],
  );
  static const SURFACE = RadialGradient(
    center: Alignment.centerRight,
    radius: 1.25,
    colors: [Colours.BACK_GLOW, Colours.BACK],
  );
  static const BLOCK = RadialGradient(
    center: Alignment.centerRight,
    radius: 5.0,
    colors: [Colours.BACK_GLOW, Colours.BACK],
  );
}

/// static const styles class - custom static const styles
final class Styles {
  static const TEXT_UN = TextStyle(
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w500,
    color: Colours.B,
  );
  static const TEXT_OVER = TextStyle(
    fontSize: 20,
    fontFamily: Fonts.RUBIK_ONE,
    color: Colours.W,
  );
  static const TEXT_BUTTON_FILLED = TextStyle(
    fontSize: 15,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w700,
    color: Colours.B,
  );
  static const TEXT_INPUT = TextStyle(
    fontSize: 17,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w600,
    color: Colours.BACK,
  );
  static const TEXT_INPUT_MULTILINE = TextStyle(
    height: 1.4,
    fontSize: 13,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w500,
    color: Colours.BACK_GLOW,
  );
  static const TEXT_INFO = TextStyle(
    fontSize: 13,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w600,
    color: Colours.UNFRONT,
  );
  static const TEXT_INPUT_ITALIC = TextStyle(
    height: 1.4,
    fontSize: 11,
    fontFamily: Fonts.RUBIK,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    color: Colours.FRONT,
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
    fillColor: Colours.o,
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
