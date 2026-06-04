import 'package:flutter/services.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/basics.dart';
import 'package:sortack/widget/dialogs.dart';
import 'package:sortack/page/kanban.dart';
import 'package:sortack/page/scrum.dart';

class ProjectCard extends StatefulWidget {
  final String id;

  const ProjectCard({super.key, required this.id});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  late final ProjectDetailsController _deckDetailsController;
  ProjectDetails get details => _deckDetailsController.project;
  set details(ProjectDetails x) => _deckDetailsController.project = x;
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
  }

  Future<void> _loadData() async {
    _isLoading = true;
    try {
      // project details
      ProjectDetails loadedDetails = await FireRources.loadProjectDetails(
        widget.id,
      );
      _deckDetailsController = ProjectDetailsController(
        loadedDetails,
        onUnfocus: () async {
          try {
            await FireRources.saveProject(details);
          } catch (exc) {
            debugPrint('? ERROR: on saving details changes; $exc');
          }
        },
      );
      // profiles data
      Map<String, UserProfile> loadedProfiles = {};
      for (final uid in details.members) {
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

  Future<void> _loadProfiles() async {
    try {
      // profiles data
      Map<String, UserProfile> loadedProfiles = {};
      for (final uid in details.members) {
        final profile = await FireRources.loadUserProfile(uid);
        if (profile != null) loadedProfiles[uid] = profile;
      }
      if (!mounted) return;
      setState(() {
        membersProfiles = loadedProfiles;
      });
    } catch (exc) {
      debugPrint('! ERROR: on loading profiles; $exc');
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
    style: Styles.TEXT_UNINPUT,
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
    style: Styles.TEXT_UNINPUT_MULTILINE,
    decoration: Decorations.INPUT_FIELD(
      padding: const EdgeInsets.fromLTRB(6.0, 12.0, 10.0, 18.0),
      labelText: 'Description',
      hoverColor: colour,
      tipColor: colourVery,
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
      membersProfiles[details.owner] != null
          ? ProfileAvatar(
              profile: membersProfiles[details.owner]!,
              radius: 20.0,
            )
          : buildLoading(size: 40.0),
      if (membersProfiles[details.owner] != null)
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
                    membersProfiles[member] != null
                        ? ProfileAvatar(
                            profile: membersProfiles[member]!,
                            radius: 12.5,
                          )
                        : buildLoading(size: 40.0),
                    if (membersProfiles[member] != null)
                      Text(
                        membersProfiles[member]!.name,
                        style: Styles.TEXT_UN,
                      ),
                  ],
                ),
          ],
        )
      : null;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 15.0,
            ),
            width: 321.0,
            height: 123.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(5.0),
                bottomLeft: Radius.circular(55.0),
                bottomRight: Radius.circular(5.0),
              ),
              border: BoxBorder.all(
                strokeAlign: BorderSide.strokeAlignCenter,
                width: 6,
                color: Colours.INK_AC,
              ),
              gradient: const RadialGradient(
                center: AlignmentGeometry.topCenter,
                radius: 1.75,
                colors: [Colours.F, Colours.INK_AC],
              ),
            ),
            child: const Center(
              child: Text(
                'waiting...',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: Fonts.RUBIK,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: Colours.O,
                ),
              ),
            ),
          )
        : StreamBuilder<ProjectDetails>(
            stream: FireRources.streamProjectDetails(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                details = snapshot.data!;
                final hasMissingProfiles = details.members.any(
                  (uid) => !membersProfiles.containsKey(uid),
                );
                if (hasMissingProfiles) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _loadProfiles();
                  });
                }
              }
              return InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15.0,
                  ),
                  width: 321.0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(55.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                    border: BoxBorder.all(
                      strokeAlign: BorderSide.strokeAlignCenter,
                      width: 6,
                      color: colour,
                    ),
                    gradient: RadialGradient(
                      center: AlignmentGeometry.topCenter,
                      radius: 1.75,
                      colors: [colour, colourVery],
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
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.link_rounded,
                              size: 23,
                              color: Colours.INK_UN,
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
                          Center(
                            child: buildMethodologyChip(details.methodology),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_rounded,
                              size: 23,
                              color: Colours.INK_UN,
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AcceptGradialog(
                                icon: Icons.delete_sweep_rounded,
                                message:
                                    'This will permanently remove the project...',
                                onAccept: delete,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => switch (details.methodology) {
                        Methodology.Kanban => KanbanPage(details: details),
                        Methodology.Scrum => ScrumPage(details: details),
                      },
                    ),
                  );
                },
              );
            },
          );
  }
}
