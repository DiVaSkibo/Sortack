import 'package:flutter_svg/flutter_svg.dart';
import 'package:sortack/_tools.dart';
//import 'package:sortack/_logics.dart';
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
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 99,
          runSpacing: 111,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 60,
              children: [
                SvgPicture.asset('assets/icon/Sortack.svg'),
                Text('Sortack welcomes!', style: Styles.TEXT_MARKER),
              ],
            ),
            AuthView(),
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
