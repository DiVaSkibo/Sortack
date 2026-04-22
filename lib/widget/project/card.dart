import 'package:flutter/services.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/basics.dart';
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
  Map<String, UserProfile> membersProfiles = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
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

  Future<void> _loadData() async {
    try {
      // profiles data
      Map<String, UserProfile> loadedProfiles = {};
      for (String uid in widget.details.members) {
        final profile = await FireRources.loadUserProfile(uid);
        if (profile != null) loadedProfiles[uid] = profile;
      }
      if (!mounted) return;
      membersProfiles = loadedProfiles;
    } catch (exc) {
      debugPrint('! ERROR: on loading data; $exc');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void delete() async {
    try {
      await FireRources.deleteDeck(details.id);
    } catch (exc) {
      debugPrint('! ERROR: on deleting project; $exc');
    }
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
  Widget _buildOwner() => Center(
    child: Row(
      children: [
        ProfileAvatar(
          name: membersProfiles[details.owner]!.name,
          avatar: membersProfiles[details.owner]!.avatar,
          radius: 17.5,
        ),
        Text(membersProfiles[details.owner]!.name),
      ],
    ),
  );
  Widget _buildMembers() => Center(
    child: Wrap(
      children: [
        for (final member in details.members)
          if (member != details.owner)
            Row(
              children: [
                ProfileAvatar(
                  name: membersProfiles[member]!.name,
                  avatar: membersProfiles[member]!.avatar,
                  radius: 12.5,
                ),
                Text(membersProfiles[member]!.name),
              ],
            ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
              ),
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
                  _buildOwner(),
                  _buildMembers(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.link_rounded),
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: details.id),
                          );
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
                            message:
                                'Do you realy want to delete this project?...',
                            onAccept: () => delete(),
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
