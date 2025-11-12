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
          cursorColor: Colors.lightGreenAccent,
          selectionColor: Colors.deepPurpleAccent,
          selectionHandleColor: Colors.pinkAccent,
        ),
        textTheme: const TextTheme(labelLarge: TextStyle(fontSize: 20)),
        primaryTextTheme: const TextTheme(labelLarge: TextStyle(fontSize: 20)),
        iconTheme: const IconThemeData(size: 20, color: Palette.WHITE),
        primaryIconTheme: const IconThemeData(size: 20, color: Palette.WHITE),
        buttonTheme: const ButtonThemeData(
          buttonColor: Palette.BG_ACCENT,
          hoverColor: Palette.FG_TRANS,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            iconSize: 20,
            visualDensity: VisualDensity.compact,
            foregroundColor: Palette.WHITE,
            disabledForegroundColor: Palette.FG_TRANS,
            hoverColor: Palette.FG_TRANS,
            highlightColor: Palette.FG_SHADOW,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            alignment: AlignmentGeometry.centerRight,
            textStyle: const TextStyle(
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
            foregroundColor: Palette.WHITE,
            overlayColor: Palette.FG_SHADOW,
            iconAlignment: IconAlignment.end,
            iconSize: 16,
            iconColor: Palette.FG_SHADOW,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            foregroundColor: Palette.WHITE,
            backgroundColor: Palette.BG_ACCENT,
            overlayColor: Palette.FG_SHADOW,
          ),
        ),
        dialogTheme: const DialogThemeData(
          alignment: Alignment.bottomRight,
          backgroundColor: Palette.BG,
          surfaceTintColor: Palette.FG_ACCENT,
          barrierColor: Palette.BARRIER,
          iconColor: Palette.FG,
        ),
        tabBarTheme: const TabBarThemeData(
          tabAlignment: TabAlignment.fill,
          labelColor: Palette.FG_SHADOW,
          labelStyle: TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w600,
          ),
          indicatorColor: Palette.FG,
          unselectedLabelColor: Palette.FG_TRANS,
          unselectedLabelStyle: TextStyle(
            fontFamily: Fonts.RUBIK,
            fontWeight: FontWeight.w600,
          ),
          dividerHeight: 2.25,
          dividerColor: Palette.BG_SHADOW,
        ),
        drawerTheme: const DrawerThemeData(
          width: 200,
          backgroundColor: Colors.transparent,
          scrimColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Palette.BG_TRANS,
          foregroundColor: Palette.WHITE,
          surfaceTintColor: Palette.BG_TRANS,
          titleTextStyle: TextStyle(
            letterSpacing: 1.5,
            fontFamily: Fonts.RUBIK_ONE,
            fontSize: 12.5,
            color: Palette.BG_ACCENT,
          ),
          iconTheme: IconThemeData(color: Palette.FG_SHADOW),
          actionsIconTheme: IconThemeData(color: Palette.FG_SHADOW),
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
