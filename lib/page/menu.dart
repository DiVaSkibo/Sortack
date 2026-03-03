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
    return Ground(
      scrollable: true,
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 50,
        runSpacing: 100,
        children: [
          ProjectCard(
            details: DeckDetails(
              name: 'Deck',
              methodology: Methodology.Kanban,
              created: DateTime.now(),
              owner: 'Wood',
            ),
          ),
          ProjectCard(
            details: DeckDetails(
              name: 'Project',
              methodology: Methodology.Scrum,
              created: DateTime.now(),
              owner: 'Product Owner',
            ),
          ),
          ProjectCard(
            details: DeckDetails(
              name: 'To do list',
              methodology: Methodology.Kanban,
              created: DateTime.now(),
              owner: 'Mom',
            ),
          ),
          ProjectCard(
            details: DeckDetails(
              name: '_',
              methodology: Methodology.Scrum,
              created: DateTime.now(),
              owner: 'Me',
            ),
          ),
          ProjectCard(
            details: DeckDetails(
              name: 'name',
              methodology: Methodology.Kanban,
              created: DateTime.now(),
              owner: 'owner',
            ),
          ),
        ],
      ),
    );
  }
}
