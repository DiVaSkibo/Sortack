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

/// accept gradialog widget - gradialog for accept action
class AcceptGradialog extends StatelessWidget {
  final String? message;
  final Function() onCancel;
  final Function() onAccept;
  final IconData? icon;

  const AcceptGradialog({
    super.key,
    this.message,
    required this.onCancel,
    required this.onAccept,
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
          onPressed: onAccept,
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colours.B),
            backgroundColor: WidgetStatePropertyAll(Colours.GOOD),
          ),
        ),
        IconButton(
          iconSize: 18,
          icon: const Icon(Icons.close_rounded, fontWeight: FontWeight.w900),
          onPressed: onCancel,
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
  final DeckDetails details;
  final Function(DeckDetails) onAccept;
  final Function() onCancel;

  const ProjectGradialog({
    super.key,
    required this.details,
    required this.onAccept,
    required this.onCancel,
  });

  @override
  State<ProjectGradialog> createState() => _ProjectGradialogState();
}

class _ProjectGradialogState extends State<ProjectGradialog> {
  late final DeckDetailsController _projectController;
  DeckDetails get project => _projectController.project;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _projectController = DeckDetailsController(widget.details);
  }

  @override
  void dispose() {
    _projectController.dispose();
    super.dispose();
  }

  Future<void> _fireProject() async {
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
    decoration: Decorations.INPUT_FIELD(collapsed: true, hintText: 'Name'),
  );
  TextFormField _buildDescription() => TextFormField(
    controller: _projectController.descriptionController,
    focusNode: _projectController.descriptionFocus,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 4,
    onTapOutside: (event) => _projectController.descriptionFocus.unfocus(),
    style: Styles.TEXT_INPUT_MULTILINE,
    decoration: Decorations.INPUT_FIELD(
      collapsed: false,
      labelText: 'Description',
    ),
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
          onPressed: _isLoading ? null : _fireProject,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colours.BOTTOM),
            textStyle: WidgetStatePropertyAll(Styles.TEXT_BUTTON_FILLED),
          ),
        ),
      ],
    );
  }
}
