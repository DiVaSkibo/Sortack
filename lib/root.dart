import 'package:firebase_auth/firebase_auth.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_pages.dart';

class Rooter extends StatelessWidget {
  const Rooter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Icon(Icons.timelapse_rounded);
        else if (snapshot.hasData)
          return KanbanPage();
        else
          return MyHomePage();
      },
    );
  }
}
