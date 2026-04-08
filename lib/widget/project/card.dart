import 'package:sortack/_logics.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/widget/dialogs.dart';
import 'package:sortack/page/kanban.dart';
import 'package:sortack/page/scrum.dart';

class ProjectCard extends StatefulWidget {
  final DeckDetails details;

  const ProjectCard({super.key, required this.details});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  late final DeckDetails details = widget.details;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 300,
      color: Colours.BOTTOM,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => switch (details.methodology) {
                Methodology.Kanban => KanbanPage(id: details.id),
                Methodology.Scrum => ScrumPage(id: details.id),
              },
            ),
          );
        },
        child: Wrap(
          spacing: 10,
          runSpacing: 15,
          children: [
            Text(details.name, style: Styles.TEXT_INPUT),
            Text(details.description ?? '', style: Styles.TEXT_INPUT_MULTILINE),
            Container(height: 125, color: Colours.CENTER),
            Text(
              '${details.methodology.label}\nby 0 ${details.owner}\nwith 0 ${details.members.toString()}\nin ${details.created}',
              style: Styles.TEXT_INPUT_ITALIC,
            ),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AcceptGradialog(
                  message: 'Do you realy want to delete this project?...',
                  onCancel: Navigator.of(context).pop,
                  onAccept: () async {
                    Navigator.of(context).pop();
                    await FireRources.deleteDeck(details.id);
                  },
                  icon: Icons.remove_rounded,
                ),
              ),
              icon: Icon(Icons.remove_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
