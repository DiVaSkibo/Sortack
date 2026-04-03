import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';

/// Scrum row class - advanced task block view for scrum methodology
class ScrumRow extends StatefulWidget {
  final String deckId, plankId;
  final AdvancedBlock task;
  final int order;
  final Function(AdvancedBlock) onDelete;

  ScrumRow({
    Key? key,
    required this.deckId,
    required this.plankId,
    required this.task,
    required this.order,
    required this.onDelete,
  }) : super(key: key ?? ObjectKey(task));

  @override
  State<ScrumRow> createState() => _ScrumRowState();
}

class _ScrumRowState extends State<ScrumRow> {
  late final AdvancedBlockController _taskController;
  AdvancedBlock get task => _taskController.task;

  @override
  void initState() {
    super.initState();
    _taskController = AdvancedBlockController(
      widget.task,
      onUnfocus: () async {
        setState(() {});
        try {
          await FireRources.saveBlock(
            widget.deckId,
            widget.plankId,
            task,
            widget.order,
          );
        } catch (exc) {
          debugPrint('? ERROR: saving task changes');
        }
      },
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Widget _buildTitle() => TextField(
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
  Widget _buildDescription() => TextFormField(
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
  Widget _buildDeadline() => Center(
    child: TextButton(
      onPressed: () async {
        DateTime? deadline = await showDatePicker(
          context: context,
          initialDate: task.deadline,
          firstDate: DateTime(1800),
          lastDate: DateTime(3000),
        );
        if (deadline != null) {
          _taskController.updateDeadline(deadline);
        }
      },
      child: Text(task.deadline != null ? task.deadline!.ddMMMyyyy : '-'),
    ),
  );
  Widget _buildStatus() => Container(
    color: task.status.colour,
    child: Center(
      child: PopupMenuButton<TaskStatus>(
        tooltip: 'status',
        initialValue: task.status,
        child: Text(task.status.label),
        itemBuilder: (context) => TaskStatus.values
            .map(
              (value) => PopupMenuItem(value: value, child: Text(value.label)),
            )
            .toList(),
        onSelected: (value) {
          _taskController.updateStatus(value);
          //onChanged();
        },
      ),
    ),
  );
  Widget _buildPriority() => Center(
    child: PopupMenuButton<TaskPriority>(
      tooltip: 'priority',
      initialValue: task.priority,
      icon: Icon(task.priority.icon, color: task.priority.colour),
      itemBuilder: (context) => TaskPriority.values
          .map((value) => PopupMenuItem(value: value, child: Text(value.label)))
          .toList(),
      onSelected: (value) {
        _taskController.updatePriority(value);
      },
    ),
  );
  Widget _buildPoints() => Center(
    child: PopupMenuButton<TaskPointsTShirt>(
      tooltip: 'points',
      initialValue: task.points,
      child: Text(task.points != null ? task.points!.label : '?'),
      itemBuilder: (context) => TaskPointsTShirt.values
          .map((value) => PopupMenuItem(value: value, child: Text(value.label)))
          .toList(),
      onSelected: (value) {
        _taskController.updatePoints(value);
      },
    ),
  );
  Widget _buildAssignee() => Center(
    child: Wrap(
      children: task.assignee.isNotEmpty
          ? List.generate(
              task.assignee.length,
              (index) => Text(task.assignee[index]),
            )
          : [Text('||||||')],
    ),
  );
  Widget _buildTags() => Center(
    child: Wrap(
      children: task.tags.isNotEmpty
          ? List.generate(task.tags.length, (index) => Text(task.tags[index]))
          : [Text('||||||')],
    ),
  );
  Widget _buildNotes() => TextFormField(
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
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(flex: 3, child: _buildTitle()),
            Expanded(flex: 4, child: _buildDescription()),
            Expanded(flex: 2, child: _buildDeadline()),
            Expanded(flex: 2, child: _buildStatus()),
            Expanded(flex: 2, child: _buildPriority()),
            Expanded(flex: 2, child: _buildPoints()),
            Expanded(flex: 2, child: _buildAssignee()),
            Expanded(flex: 2, child: _buildTags()),
            Expanded(flex: 3, child: _buildNotes()),
          ],
        ),
      ),
    );
  }
}
