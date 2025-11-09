import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sortack/tool/_palette.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomCenter,
            radius: 1.0,
            colors: [Palette.BG_SHADOW, Palette.BG],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 60,
          children: <Widget>[
            SvgPicture.asset('assets/icon/Sortack.svg'),
            Text(
              'Sortack welcomes!',
              style: TextStyle(fontFamily: 'Rubik Mono One', fontSize: 60),
            ),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, 'kanban'),
              child: Text('Join it'),
            ),
          ],
        ),
      ),
    );
  }
}
