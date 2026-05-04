import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';

/// gradialog - dialog with gradient
class Gradialog extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final Widget? content;
  final List<Widget>? actions;

  const Gradialog({
    super.key,
    this.icon,
    this.title,
    this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          gradient: Gradients.BLOCK,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 15,
          children: [
            if (title != null) Text(title!),
            if (icon != null) Icon(icon),
          ],
        ),
      ),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: Gradients.BLOCK,
        ),
        child: content,
      ),
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
      title: 'What colour do you prefer?...',
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
              for (final colour in Colours.STATIC)
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
      title: 'Sure?',
      content: Text(message ?? 'are you sure?...'),
      actions: [
        IconButton(
          iconSize: 18,
          icon: const Icon(Icons.check_rounded, fontWeight: FontWeight.w900),
          onPressed: () {
            Navigator.of(context).pop();
            onAccept?.call();
          },
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colours.B),
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
            foregroundColor: WidgetStatePropertyAll(Colours.B),
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
      icon: Icons.catching_pokemon_rounded,
      title: 'Pick what you want',
      content: Wrap(
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
            foregroundColor: WidgetStatePropertyAll(Colours.B),
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
            foregroundColor: WidgetStatePropertyAll(Colours.B),
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
  bool _isLoading = false;

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
    setState(() => _isLoading = true);
    try {
      FireRources.saveProject(project);
      if (mounted) Navigator.pop(context);
    } catch (exc) {
      debugPrint('! ERROR: $exc');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  TextField _buildName() => TextField(
    controller: _projectController.nameController,
    focusNode: _projectController.nameFocus,
    onEditingComplete: () => _projectController.nameFocus.unfocus(),
    onTapOutside: (event) => _projectController.nameFocus.unfocus(),
    style: Styles.TEXT_INPUT,
    decoration: Decorations.INPUT_FIELD(hintText: 'Name'),
  );
  TextFormField _buildDescription() => TextFormField(
    controller: _projectController.descriptionController,
    focusNode: _projectController.descriptionFocus,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 4,
    onTapOutside: (event) => _projectController.descriptionFocus.unfocus(),
    style: Styles.TEXT_INPUT_MULTILINE,
    decoration: Decorations.INPUT_FIELD(labelText: 'Description'),
  );
  PopupMenuButton _buildMethodology() => PopupMenuButton<Methodology>(
    tooltip: 'methodology',
    initialValue: project.methodology,
    child: Text(project.methodology.label),
    itemBuilder: (context) => Methodology.values
        .map((value) => PopupMenuItem(value: value, child: Text(value.label)))
        .toList(),
    onSelected: (Methodology value) {
      setState(() {
        _projectController.updateMethodology(value);
      });
    },
  );

  @override
  Widget build(BuildContext context) {
    return Gradialog(
      icon: Icons.new_label_rounded,
      title: 'Project setting',
      content: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [_buildName(), _buildDescription(), _buildMethodology()],
      ),
      actions: [
        FilledButton.icon(
          icon: _isLoading
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.create_new_folder_rounded),
          label: Text('create'),
          onPressed: _isLoading ? null : fire,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colours.BOTTOM),
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

  @override
  Widget build(BuildContext context) {
    return Gradialog(
      title: 'Join the project',
      content: TextField(
        controller: _codeController,
        decoration: const InputDecoration(
          hintText: 'Введіть код...',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        IconButton(
          iconSize: 18,
          icon: const Icon(Icons.check_rounded, fontWeight: FontWeight.w900),
          onPressed: () {
            final code = _codeController.text.trim();
            if (code.isEmpty) return;
            FireRources.joinProject(
              code,
              FirebaseAuth.instance.currentUser!.uid,
            );
            Navigator.pop(context);
          },
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colours.B),
            backgroundColor: WidgetStatePropertyAll(Colours.GOOD),
          ),
        ),
        IconButton(
          iconSize: 18,
          icon: const Icon(Icons.close_rounded, fontWeight: FontWeight.w900),
          onPressed: () => Navigator.pop(context),
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colours.B),
            backgroundColor: WidgetStatePropertyAll(Colours.BAD),
          ),
        ),
      ],
    );
  }
}
