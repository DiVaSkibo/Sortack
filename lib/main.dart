import 'package:flutter/material.dart';
import 'tool/_palette.dart';
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
        fontFamily: 'Rubik',
        textTheme: TextTheme(labelLarge: TextStyle(fontSize: 20)),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            foregroundColor: Palette.WHITE,
            backgroundColor: Palette.BG_ACCENT,
          ),
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
