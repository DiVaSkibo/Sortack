import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/basics.dart';

/// gradialog - dialog with gradient
class Gradialog extends StatelessWidget {
  final double width;
  final IconData? icon;
  final String? title;
  final Widget? content;
  final List<Widget>? actions;

  const Gradialog({
    super.key,
    this.width = double.infinity,
    this.icon,
    this.title,
    this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        width: width,
        alignment: AlignmentGeometry.center,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          gradient: Gradients.BUBBLE,
        ),
        child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            if (icon != null) Icon(icon, color: Colours.INK_UN),
            if (title != null) Text(title!, style: Styles.TEXT_UN),
          ],
        ),
      ),
      content: content != null
          ? Container(
              width: width,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30.0,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                gradient: Gradients.BLOCK,
              ),
              child: content,
            )
          : null,
      actions: actions,
    );
  }
}

/// colour gradialog widget - gradialog for colour picking
class ColourGradialog extends StatelessWidget {
  const ColourGradialog({super.key});

  Widget _buildColour(BuildContext context, Color colour) => GestureDetector(
    onTap: () {
      Navigator.of(context).pop(colour);
    },
    child: Container(
      width: 36.0,
      height: 36.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: colour),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Gradialog(
      icon: Icons.color_lens_rounded,
      title: 'Which color are we choosing?...',
      content: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 7,
        children: [
          Row(
            spacing: 7,
            children: [
              for (final colour in Colours.RAINBOW.reversed)
                _buildColour(context, colour),
            ],
          ),
          Row(
            spacing: 7,
            children: [
              for (final colour in Colours.TRAFFIC.reversed)
                _buildColour(context, colour),
            ],
          ),
          Row(
            spacing: 7,
            children: [
              for (final colour in Colours.BINARY.reversed)
                _buildColour(context, colour),
            ],
          ),
          Row(
            spacing: 7,
            children: [
              for (final colour in Colours.STATIC.reversed)
                _buildColour(context, colour),
            ],
          ),
        ],
      ),
    );
  }
}

/// accept gradialog widget - gradialog for accept action
class AcceptGradialog extends StatelessWidget {
  final String? message;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final IconData? icon;

  const AcceptGradialog({
    super.key,
    this.message,
    this.onAccept,
    this.onCancel,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Gradialog(
      icon: icon,
      title: message != null && message!.isNotEmpty
          ? '$message\nconfirm action?'
          : 'confirm action?',
      actions: [
        IconButton(
          iconSize: 18,
          icon: const Icon(Icons.check_rounded, fontWeight: FontWeight.w900),
          onPressed: () {
            Navigator.of(context).pop();
            onAccept?.call();
          },
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colours.O),
            backgroundColor: WidgetStatePropertyAll(Colours.GOOD),
          ),
        ),
        IconButton(
          iconSize: 18,
          icon: const Icon(Icons.close_rounded, fontWeight: FontWeight.w900),
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colours.O),
            backgroundColor: WidgetStatePropertyAll(Colours.BAD),
          ),
        ),
      ],
    );
  }
}

/// chips gradialog widget - gradialog for picking chips
class ChipsGradialog extends StatefulWidget {
  final Set values;
  final Set? selected;
  final Function(Set)? onPick;
  final VoidCallback? onCancel;

  const ChipsGradialog({
    super.key,
    required this.values,
    this.selected,
    this.onPick,
    this.onCancel,
  });

  @override
  State<ChipsGradialog> createState() => _ChipsGradialogState();
}

class _ChipsGradialogState extends State<ChipsGradialog> {
  late final values = widget.values;
  late final selected = widget.selected ?? {};

  @override
  Widget build(BuildContext context) {
    return Gradialog(
      width: 300.0,
      icon: Icons.rule_folder_rounded,
      title: 'Pick everything that applies!',
      content: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 10,
        children: values.map((value) {
          String text;
          dynamic val = value;
          if (value is String)
            text = value;
          else if (value is Labeling)
            text = value.label;
          else if (value is UserProfile) {
            text = value.name;
            val = value.id;
          } else
            text = value.toString();
          return ChoiceChip(
            selected: selected.contains(val),
            color: val is Tag
                ? WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.selected))
                      return val.colour;
                    else
                      return (val.colour as Color).withAlpha(125);
                  })
                : null,
            label: Text(text),
            onSelected: (v) {
              setState(() {
                if (v)
                  selected.add(val);
                else
                  selected.remove(val);
              });
            },
          );
        }).toList(),
      ),
      actions: [
        IconButton(
          iconSize: 18,
          icon: const Icon(Icons.check_rounded, fontWeight: FontWeight.w900),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onPick?.call(selected);
          },
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colours.O),
            backgroundColor: WidgetStatePropertyAll(Colours.GOOD),
          ),
        ),
        IconButton(
          iconSize: 18,
          icon: const Icon(Icons.close_rounded, fontWeight: FontWeight.w900),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onCancel?.call();
          },
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colours.O),
            backgroundColor: WidgetStatePropertyAll(Colours.BAD),
          ),
        ),
      ],
    );
  }
}

/// project gradialog widget - gradialog for project settings
class ProjectGradialog extends StatefulWidget {
  final ProjectDetails? details;

  const ProjectGradialog({super.key, this.details});

  @override
  State<ProjectGradialog> createState() => _ProjectGradialogState();
}

class _ProjectGradialogState extends State<ProjectGradialog> {
  late final ProjectDetailsController _projectController;
  ProjectDetails get project => _projectController.project;

  @override
  void initState() {
    super.initState();
    _projectController = ProjectDetailsController(
      widget.details ??
          ProjectDetails(
            id: '#',
            name: '',
            methodology: Methodology.Kanban,
            created: DateTime.now(),
            owner: '',
          ),
    );
  }

  @override
  void dispose() {
    _projectController.dispose();
    super.dispose();
  }

  Future<void> fire() async {
    if (project.name.trim().isEmpty) return;
    try {
      FireRources.saveProject(project);
      if (mounted) Navigator.pop(context);
    } catch (exc) {
      debugPrint('! ERROR: $exc');
    }
  }

  Widget _buildName() => TextField(
    controller: _projectController.nameController,
    focusNode: _projectController.nameFocus,
    onEditingComplete: () => _projectController.nameFocus.unfocus(),
    onTapOutside: (event) => _projectController.nameFocus.unfocus(),
    style: Styles.TEXT_INPUT,
    decoration: Decorations.INPUT_FIELD(labelText: 'Name'),
  );
  Widget _buildDescription() => TextFormField(
    controller: _projectController.descriptionController,
    focusNode: _projectController.descriptionFocus,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 4,
    onTapOutside: (event) => _projectController.descriptionFocus.unfocus(),
    style: Styles.TEXT_INPUT_MULTILINE,
    decoration: Decorations.INPUT_FIELD(labelText: 'Description'),
  );
  Widget _buildMethodology() => buildMethodologyChip(
    project.methodology,
    onPressed: () {
      setState(() {
        _projectController.updateMethodology(
          Methodology.values[(project.methodology.index + 1) %
              Methodology.values.length],
        );
      });
    },
  );

  @override
  Widget build(BuildContext context) {
    return Gradialog(
      icon: Icons.new_label_rounded,
      title: 'Let`s set up your new project...',
      content: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 15,
        children: [_buildName(), _buildDescription(), _buildMethodology()],
      ),
      actions: [
        FilledButton.icon(
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('create'),
          onPressed: fire,
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(
              EdgeInsetsGeometry.symmetric(horizontal: 10.0, vertical: 20.0),
            ),
            backgroundColor: WidgetStatePropertyAll(Colours.DRIVE_AC),
            textStyle: WidgetStatePropertyAll(Styles.TEXT_BUTTON_FILLED),
          ),
        ),
      ],
    );
  }
}

class JoinGradialog extends StatefulWidget {
  const JoinGradialog({super.key});

  @override
  State<JoinGradialog> createState() => _JoinGradialogState();
}

class _JoinGradialogState extends State<JoinGradialog> {
  final TextEditingController _codeController = TextEditingController();

  Future<void> fire() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    FireRources.joinProject(code, FirebaseAuth.instance.currentUser!.uid);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Gradialog(
      icon: Icons.label_important_rounded,
      title: 'Let`s connect to an existing project...',
      content: TextField(
        controller: _codeController,
        decoration: Decorations.INPUT_FIELD(labelText: 'Code'),
      ),
      actions: [
        FilledButton.icon(
          icon: const Icon(Icons.connect_without_contact_rounded, size: 20),
          label: const Text('join'),
          onPressed: fire,
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(
              EdgeInsetsGeometry.symmetric(horizontal: 10.0, vertical: 20.0),
            ),
            backgroundColor: WidgetStatePropertyAll(Colours.SHIFT_AC),
            textStyle: WidgetStatePropertyAll(Styles.TEXT_BUTTON_FILLED),
          ),
        ),
      ],
    );
  }
}
