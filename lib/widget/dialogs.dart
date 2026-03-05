import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';

/// accept dialog widget - dialog for accept action
class AcceptDialog extends StatelessWidget {
  final String? message;
  final Function() onCancel;
  final Function() onAccept;
  final IconData? icon;

  const AcceptDialog({
    super.key,
    this.message,
    required this.onCancel,
    required this.onAccept,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon != null ? Icon(icon, size: 40) : null,
      content: Text(message ?? 'are you sure?...'),
      actions: [
        IconButton(onPressed: onCancel, icon: Icon(Icons.close_rounded)),
        IconButton(onPressed: onAccept, icon: Icon(Icons.check_rounded)),
      ],
    );
  }
}

/// ?
class ProjectDialog extends StatefulWidget {
  final DeckDetails project;
  final Function(DeckDetails) onAccept;
  final Function() onCancel;

  const ProjectDialog({
    super.key,
    required this.project,
    required this.onAccept,
    required this.onCancel,
  });

  @override
  State<ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  late final DeckDetailsController _projectController;
  DeckDetails get project => _projectController.project;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _projectController = DeckDetailsController(widget.project);
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
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('User is not authorised...');
      await FirebaseFirestore.instance.collection('projects').add({
        'name': project.name.trim(),
        'description': project.description,
        'methodology': project.methodology.name,
        'created': FieldValue.serverTimestamp(),
        'owner': currentUser.uid,
        'members': [currentUser.uid],
      });
      debugPrint(
        {
          'name': project.name.trim(),
          'description': project.description,
          'methodology': project.methodology.name,
          'createdAt': FieldValue.serverTimestamp(),
          'owner': currentUser.uid,
          'members': [currentUser.uid],
        }.toString(),
      );
      if (mounted) Navigator.pop(context);
    } catch (exc) {
      debugPrint('! ERROR: $exc');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  TextField _buildNameField() => TextField(
    controller: _projectController.nameController,
    focusNode: _projectController.nameFocus,
    onEditingComplete: () => _projectController.nameFocus.unfocus(),
    onTapOutside: (event) => _projectController.nameFocus.unfocus(),
    style: Styles.TASK_TITLE_TEXT,
    decoration: Decorations.cardInput(collapsed: true, hintText: 'Name'),
  );
  TextFormField _buildDescriptionField() => TextFormField(
    controller: _projectController.descriptionController,
    focusNode: _projectController.descriptionFocus,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 4,
    onTapOutside: (event) => _projectController.descriptionFocus.unfocus(),
    style: Styles.TASK_DESCRIPTION_TEXT,
    decoration: Decorations.cardInput(
      collapsed: false,
      labelText: 'Description',
    ),
  );
  PopupMenuButton _buildMethodologyField() => PopupMenuButton<Methodology>(
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
    return AlertDialog(
      title: Icon(Icons.new_label_rounded),
      content: Column(
        children: [
          _buildNameField(),
          _buildDescriptionField(),
          _buildMethodologyField(),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _isLoading ? null : _fireProject,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.create_new_folder_rounded),
        ),
      ],
    );
  }
}
