import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/dialogs.dart';

/// Kanban card widget - task block view
class KanbanCard extends StatefulWidget {
  final String deckId, plankId;
  final Block task;
  final int order;
  final Function(Block) onDelete;

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
  late final BlockController _taskController;
  Block get task => _taskController.task;

  @override
  void initState() {
    super.initState();
    _taskController = BlockController(
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

  Widget _buildTitle() => TextField(
    controller: _taskController.titleController,
    focusNode: _taskController.titleFocus,
    onEditingComplete: () => _taskController.titleFocus.unfocus(),
    onTapOutside: (event) => _taskController.titleFocus.unfocus(),
    style: Styles.TEXT_INPUT,
    decoration: Decorations.INPUT_FIELD(
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
    style: Styles.TEXT_INPUT_MULTILINE,
    decoration: Decorations.INPUT_FIELD(
      collapsed: false,
      labelText: 'Description',
    ),
  );
  Widget _buildDeadline() => TextButton(
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
    child: Text(
      task.deadline != null ? task.deadline!.ddMMMyyyy : '-',
      style: Styles.TEXT_INPUT_MULTILINE,
    ),
  );
  Widget _buildPoints() => PopupMenuButton<PointsTShirt>(
    tooltip: 'points',
    initialValue: task.points,
    icon: Text(
      task.points != null ? task.points!.label : '?',
      style: Styles.TEXT_INPUT,
    ),
    itemBuilder: (context) => PointsTShirt.values
        .map((value) => PopupMenuItem(value: value, child: Text(value.label)))
        .toList(),
    onSelected: (points) {
      _taskController.updatePoints(points);
    },
  );
  Widget _buildAssignee() => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      for (final assignee in task.assignee)
        ChoiceChip(label: Text(assignee), selected: true),
      InputChip(
        label: Icon(Icons.settings_input_composite_outlined),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ChipsGradialog(
            values: {
              'Me',
              'You',
              'Brain',
              'Eye',
              'Heart',
              'Perfection',
              'Chaos',
            },
            selected: task.assignee.toSet(),
            onPick: (assignee) {
              Navigator.of(context).pop();
              _taskController.updateAssignee(assignee as Set<String>);
            },
            onCancel: Navigator.of(context).pop,
          ),
        ),
      ),
    ],
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
        title: _buildTitle(),
        subtitle: _buildAssignee(),
        trailing: IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AcceptGradialog(
              icon: Icons.delete_sweep_rounded,
              message: 'Do you realy want to delete this task?...',
              onAccept: () async {
                Navigator.of(context).pop();
                widget.onDelete(task);
                await FireRources.deleteBlock(widget.deckId, task.id);
              },
              onCancel: Navigator.of(context).pop,
            ),
          ),
          icon: const Icon(Icons.delete_sweep_outlined),
        ),
        children: [
          _buildDescription(),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: MediaQuery.of(context).size.width / 30,
            children: [_buildPoints(), const Spacer(), _buildDeadline()],
          ),
        ],
      ),
    );
  }
}
