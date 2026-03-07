import 'package:sortack/_logics.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/page/kanban.dart';

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
            MaterialPageRoute(builder: (context) => KanbanPage(id: details.id)),
          );
        },
        child: Wrap(
          spacing: 10,
          runSpacing: 15,
          children: [
            Text(details.name, style: Styles.TASK_TITLE_TEXT),
            Text(
              details.description ?? '',
              style: Styles.TASK_DESCRIPTION_TEXT,
            ),
            Container(height: 125, color: Colours.CENTER),
            Text(
              '${details.methodology.label}\nby 0 ${details.owner}\nwith 0 ${details.members.toString()}\nin ${details.created}',
              style: Styles.TASK_NOTES_TEXT,
            ),
          ],
        ),
      ),
    );
  }
}
