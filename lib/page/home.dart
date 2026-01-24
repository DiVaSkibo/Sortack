import 'package:flutter_svg/flutter_svg.dart';
import 'package:sortack/tool/_consts.dart';
import 'package:sortack/elements/_base.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 60,
          children: <Widget>[
            SvgPicture.asset('assets/icon/Sortack.svg'),
            Text(
              'Sortack welcomes!',
              style: TextStyle(fontFamily: Fonts.RUBIK_MONO_ONE, fontSize: 60),
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
