import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/dialogs.dart';

/// Kanban card widget - task block view
class KanbanCard extends StatefulWidget {
  final String deckId, plankId;
  final TaskBlock task;
  final int order;
  final Function(TaskBlock) onDelete;

  KanbanCard({
    Key? key,
    required this.deckId,
    required this.plankId,
    required this.task,
    required this.order,
    required this.onDelete,
  }) : super(key: key ?? ObjectKey(task));

  @override
  State<KanbanCard> createState() => _KanbanCardState();
}

class _KanbanCardState extends State<KanbanCard> {
  late final TaskBlockController _taskController;
  TaskBlock get task => _taskController.task;

  @override
  void initState() {
    super.initState();
    _taskController = TaskBlockController(
      widget.task,
      onUnfocus: () async {
        try {
          await FireRources.saveBlock(
            widget.deckId,
            widget.plankId,
            task,
            widget.order,
          );
        } catch (exc) {
          debugPrint('? ERROR: saving task changes; $exc');
        }
      },
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  TextField _buildTitleField() => TextField(
    controller: _taskController.titleController,
    focusNode: _taskController.titleFocus,
    onEditingComplete: () => _taskController.titleFocus.unfocus(),
    onTapOutside: (event) => _taskController.titleFocus.unfocus(),
    style: Styles.TASK_TITLE_TEXT,
    decoration: Decorations.cardInput(
      collapsed: true,
      hintText: 'I have to do ...',
    ),
  );
  TextFormField _buildDescriptionField() => TextFormField(
    controller: _taskController.descriptionController,
    focusNode: _taskController.descriptionFocus,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 4,
    onTapOutside: (event) => _taskController.descriptionFocus.unfocus(),
    style: Styles.TASK_DESCRIPTION_TEXT,
    decoration: Decorations.cardInput(
      collapsed: false,
      labelText: 'Description',
    ),
  );
  PopupMenuButton _buildPointsField() => PopupMenuButton<TaskPointsTShirt>(
    tooltip: 'points',
    initialValue: task.points,
    child: Text(task.points != null ? task.points!.label : '?'),
    itemBuilder: (context) => TaskPointsTShirt.values
        .map((value) => PopupMenuItem(value: value, child: Text(value.label)))
        .toList(),
    onSelected: (TaskPointsTShirt value) {
      setState(() {
        _taskController.updatePoints(value);
      });
    },
  );
  TextFormField _buildNotesField() => TextFormField(
    controller: _taskController.notesController,
    focusNode: _taskController.notesFocus,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 2,
    onTapOutside: (event) => _taskController.notesFocus.unfocus(),
    style: Styles.TASK_NOTES_TEXT,
    decoration: Decorations.cardInput(collapsed: false, labelText: 'Notes'),
  );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _taskController,
      builder: (context, child) => ExpansionTile(
        maintainState: true,
        expandedCrossAxisAlignment: CrossAxisAlignment.center,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34),
          side: BorderSide.none,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34),
          side: BorderSide.none,
        ),
        leading: const Icon(Icons.task_rounded),
        title: _buildTitleField(),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AcceptDialog(
                  message: 'Do you realy want to delete this task?...',
                  onCancel: Navigator.of(context).pop,
                  onAccept: () async {
                    Navigator.of(context).pop();
                    widget.onDelete(task);
                    await FireRources.deleteBlock(widget.deckId, task.id);
                  },
                  icon: Icons.remove_rounded,
                ),
              ),
              icon: Icon(Icons.remove_rounded),
            ),
          ],
        ),
        trailing: _buildPointsField(),
        children: [_buildDescriptionField(), _buildNotesField()],
      ),
    );
  }
}
