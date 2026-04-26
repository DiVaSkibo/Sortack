import 'package:flutter_svg/flutter_svg.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_widgets.dart';

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
        scrollable: true,
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 40,
          runSpacing: 100,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 40,
              children: [
                SvgPicture.asset('assets/icon/Sortack.svg', height: 321.0),
                Text(
                  'Sortack welcomes!',
                  style: TextStyle(
                    fontFamily: Fonts.RUBIK_MARKER_HATCH,
                    fontSize: 50,
                  ),
                ),
              ],
            ),
            AuthView(),
          ],
        ),
      ),
    );
  }
}
