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

  Color get colour => switch (details.methodology) {
    Methodology.Kanban => Colours.HIGH,
    Methodology.Scrum => Colours.LOW,
  };
  Color get colourVery => switch (details.methodology) {
    Methodology.Kanban => Colours.VERY_HIGH,
    Methodology.Scrum => Colours.VERY_LOW,
  };

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
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      hintText: 'I call it ...',
      hoverColor: colour,
      tipColor: colourVery,
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
      padding: const EdgeInsets.fromLTRB(6.0, 12.0, 10.0, 18.0),
      labelText: 'Description',
      hoverColor: colour,
      tipColor: colourVery,
    ),
  );
  Widget _buildMethodology() => Center(
    child: Chip(
      label: Text(
        details.methodology.label,
        style: TextStyle(
          fontSize: 13,
          fontFamily: Fonts.RUBIK,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          color: Colours.UNFRONT,
        ),
      ),
      backgroundColor: colour,
      side: BorderSide(
        strokeAlign: BorderSide.strokeAlignCenter,
        width: 3,
        color: colourVery,
      ),
    ),
  );
  Widget _buildCreated() => Wrap(
    alignment: WrapAlignment.end,
    runAlignment: WrapAlignment.end,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 8,
    runSpacing: 4,
    children: [
      Text(
        'in',
        style: TextStyle(
          fontFamily: Fonts.RUBIK,
          fontWeight: FontWeight.w500,
          color: colourVery,
        ),
      ),
      Text(details.created.ddMMMyyyy, style: Styles.TEXT_UN),
    ],
  );
  Widget _buildOwner() => Wrap(
    alignment: WrapAlignment.start,
    runAlignment: WrapAlignment.start,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 8,
    runSpacing: 4,
    children: [
      Text(
        'by',
        style: TextStyle(
          fontFamily: Fonts.RUBIK,
          fontWeight: FontWeight.w500,
          color: colourVery,
        ),
      ),
      ProfileAvatar(profile: membersProfiles[details.owner]!, radius: 20.0),
      Text(membersProfiles[details.owner]!.name, style: Styles.TEXT_UN),
    ],
  );
  Widget? _buildMembers() => details.members.skip(1).isNotEmpty
      ? Wrap(
          alignment: WrapAlignment.end,
          runAlignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              'with',
              style: TextStyle(
                fontFamily: Fonts.RUBIK,
                fontWeight: FontWeight.w500,
                color: colourVery,
              ),
            ),
            for (final member in details.members)
              if (member != details.owner)
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 3,
                  children: [
                    ProfileAvatar(
                      profile: membersProfiles[member]!,
                      radius: 12.5,
                    ),
                    Text(membersProfiles[member]!.name, style: Styles.TEXT_UN),
                  ],
                ),
          ],
        )
      : null;

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
              width: 321.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(55.0),
                  bottomRight: Radius.circular(5.0),
                ),
                border: BoxBorder.all(
                  strokeAlign: BorderSide.strokeAlignCenter,
                  width: 6,
                  color: switch (details.methodology) {
                    Methodology.Kanban => Colours.HIGH,
                    Methodology.Scrum => Colours.LOW,
                  },
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 15,
                children: [
                  _buildName(),
                  _buildDescription(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10,
                    children: [_buildOwner(), _buildCreated()],
                  ),
                  ?_buildMembers(),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.link_rounded,
                          size: 23,
                          color: Colours.UNFRONT,
                        ),
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
                      _buildMethodology(),
                      IconButton(
                        icon: Icon(
                          Icons.remove_rounded,
                          size: 23,
                          color: Colours.UNFRONT,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AcceptGradialog(
                            message:
                                'Do you realy want to delete this project?...',
                            onAccept: () => delete(),
                            icon: Icons.remove_rounded,
                          ),
                        ),
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
