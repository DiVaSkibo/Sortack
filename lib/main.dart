import 'package:flutter/material.dart';
import 'tool/_style.dart';
import 'page/home.dart';
import 'page/kanban.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sortack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: Fonts.RUBIK,
        shadowColor: Colors.transparent,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colours.OK,
          selectionColor: Colours.FRONT,
          selectionHandleColor: Colours.UNFRONT,
        ),
        textTheme: const TextTheme(labelLarge: TextStyle(fontSize: 20)),
        primaryTextTheme: const TextTheme(labelLarge: TextStyle(fontSize: 20)),
        iconTheme: const IconThemeData(size: 20, color: Colours.LIGHT),
        primaryIconTheme: const IconThemeData(size: 20, color: Colours.LIGHT),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colours.BACK_GLOW,
          hoverColor: Colours.GLOSS,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            iconSize: 20,
            visualDensity: VisualDensity.compact,
            foregroundColor: Colours.LIGHT,
            disabledForegroundColor: Colours.GLOSS,
            hoverColor: Colours.GLOSS,
            highlightColor: Colours.UNFRONT,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            alignment: AlignmentGeometry.centerRight,
            textStyle: const TextStyle(
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            foregroundColor: Colours.LIGHT,
            overlayColor: Colours.UNFRONT,
            iconAlignment: IconAlignment.end,
            iconSize: 16,
            iconColor: Colours.UNFRONT,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shadowColor: Colors.transparent,
            foregroundColor: Colours.LIGHT,
            backgroundColor: Colours.BACK_GLOW,
            overlayColor: Colours.UNFRONT,
            textStyle: const TextStyle(
              fontSize: 15,
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colours.SHADOW,
          hoverColor: Colours.TINGE,
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colours.FRONT,
          ),
          hintStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: Colours.UNFRONT,
          ),
          helperStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            wordSpacing: 2,
            color: Colours.INACCENT,
          ),
          prefixStyle: TextStyle(fontSize: 13, color: Colours.UNACCENT),
          suffixStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colours.UNACCENT,
          ),
          counterStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            color: Colours.INACCENT,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colours.BACK, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(17)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0),
            borderRadius: BorderRadius.all(Radius.circular(17)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colours.FRONT, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(17)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colours.NOTOK, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(17)),
          ),
        ),
        dialogTheme: const DialogThemeData(
          alignment: Alignment.bottomRight,
          backgroundColor: Colours.BACK,
          surfaceTintColor: Colours.ACCENT,
          barrierColor: Colours.SHADOW,
          iconColor: Colours.FRONT,
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colours.WARNING),
            elevation: WidgetStatePropertyAll(8),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
          ),
          textStyle: TextStyle(
            color: Colours.WARNING,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          tabAlignment: TabAlignment.fill,
          labelColor: Colours.UNFRONT,
          labelStyle: TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w600,
          ),
          indicatorColor: Colours.FRONT,
          unselectedLabelColor: Colours.GLOSS,
          unselectedLabelStyle: TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w600,
          ),
          dividerHeight: 2.25,
          dividerColor: Colours.WARNING,
        ),
        drawerTheme: const DrawerThemeData(
          width: 200,
          backgroundColor: Colors.transparent,
          scrimColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colours.BACK,
          foregroundColor: Colours.LIGHT,
          surfaceTintColor: Colours.BACK,
          titleTextStyle: TextStyle(
            letterSpacing: 1.5,
            fontFamily: Fonts.RUBIK_ONE,
            fontSize: 12.5,
            color: Colours.BACK_GLOW,
          ),
          iconTheme: IconThemeData(color: Colours.UNFRONT),
          actionsIconTheme: IconThemeData(color: Colours.UNFRONT),
        ),
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => const MyHomePage(),
        'kanban': (context) => const KanbanPage(),
      },
    );
  }
}
