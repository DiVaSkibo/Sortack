import 'package:flutter/services.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/widget/dialogs.dart';
import 'package:sortack/page/kanban.dart';
import 'package:sortack/page/scrum.dart';

class ProjectCard extends StatefulWidget {
  final ProjectDetails details;

  const ProjectCard({super.key, required this.details});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  late final ProjectDetailsController _deckDetailsController;
  ProjectDetails get details => _deckDetailsController.project;

  @override
  void initState() {
    super.initState();
    _deckDetailsController = ProjectDetailsController(
      widget.details,
      onUnfocus: () async {
        try {
          await FireRources.saveProject(details);
        } catch (exc) {
          debugPrint('? ERROR: saving details changes; $exc');
        }
      },
    );
  }

  Widget _buildName() => TextField(
    controller: _deckDetailsController.nameController,
    focusNode: _deckDetailsController.nameFocus,
    onEditingComplete: () => _deckDetailsController.nameFocus.unfocus(),
    onTapOutside: (event) => _deckDetailsController.nameFocus.unfocus(),
    style: Styles.TEXT_INPUT,
    decoration: Decorations.INPUT_FIELD(
      collapsed: true,
      hintText: 'I call it ...',
    ),
  );
  Widget _buildDescription() => TextFormField(
    controller: _deckDetailsController.descriptionController,
    focusNode: _deckDetailsController.descriptionFocus,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 4,
    onTapOutside: (event) => _deckDetailsController.descriptionFocus.unfocus(),
    style: Styles.TEXT_INPUT_MULTILINE,
    decoration: Decorations.INPUT_FIELD(
      collapsed: false,
      labelText: 'Description',
    ),
  );
  // Widget _buildAssignee() => Center(
  //   child: Wrap(
  //     children: task.assignee.isNotEmpty
  //         ? List.generate(
  //             task.assignee.length,
  //             (index) => Text(task.assignee[index]),
  //           )
  //         : [Text('||||||')],
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        width: 275,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(55.0),
            bottomRight: Radius.circular(5.0),
          ),
          gradient: RadialGradient(
            center: AlignmentGeometry.topCenter,
            radius: 1.75,
            colors: switch (details.methodology) {
              Methodology.Kanban => [Colours.HIGH, Colours.VERY_HIGH],
              Methodology.Scrum => [Colours.LOW, Colours.VERY_LOW],
            },
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 10,
          runSpacing: 15,
          children: [
            _buildName(),
            _buildDescription(),
            Row(
              children: [
                Text('created in ${details.created.ddMMMyyyy}'),
                Spacer(),
                Chip(label: Text(details.methodology.label)),
              ],
            ),
            Container(height: 100, color: Colours.UNBACK),
            Text(
              'by 0 ${details.owner}\nwith 0 ${details.members.toString()}',
              style: Styles.TEXT_INPUT_ITALIC,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.link_rounded),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: details.id));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied the project code '),
                        ),
                      );
                    }
                  },
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
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => switch (details.methodology) {
              Methodology.Kanban => KanbanPage(details: details),
              Methodology.Scrum => ScrumPage(details: details),
            },
          ),
        );
      },
    );
  }
}
