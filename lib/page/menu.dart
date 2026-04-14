import 'package:sortack/_logics.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_widgets.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null)
      return Center(child: Icon(Icons.error_outline_rounded));
    return Scaffold(
      body: Ground(
        scrollable: true,
        child: StreamBuilder(
          stream: FireRources.getUserDecks(currentUser).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError)
              return Center(
                child: ListTile(
                  leading: Icon(Icons.error_outline_rounded),
                  trailing: Text(snapshot.error.toString()),
                ),
              );
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
              return Icon(Icons.cabin_rounded);
            return Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 50,
              runSpacing: 100,
              children: snapshot.data!.docs
                  .map(
                    (doc) => ProjectCard(
                      key: ValueKey(doc.id),
                      details: FireRources.loadDeckDetails(doc),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
      floatingActionButton: Wrap(
        children: [
          FloatingActionButton(
            child: Icon(Icons.add_box_rounded),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ProjectGradialog(
                details: DeckDetails(
                  id: '#',
                  name: '',
                  methodology: Methodology.Kanban,
                  created: DateTime.now(),
                  owner: '',
                ),
                onAccept: (_) {},
                onCancel: () {},
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => JoinGradialog(),
            ),
            child: Icon(Icons.explore_rounded),
          ),
        ],
      ),
    );
  }
}
