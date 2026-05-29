import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/basics.dart';
import 'package:sortack/widget/dialogs.dart';

/// Kanban card widget - task block view
class KanbanCard extends StatefulWidget {
  final String deckId, plankId;
  final Block task;
  final int order;
  final Map<String, UserProfile> members;
  final VoidCallback onDelete;

  KanbanCard({
    Key? key,
    required this.deckId,
    required this.plankId,
    required this.task,
    required this.order,
    Map<String, UserProfile>? members,
    required this.onDelete,
  }) : members = members ?? {},
       super(key: key ?? ObjectKey(task));

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
          debugPrint('? ERROR: on saving task changes; $exc');
        }
      },
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void delete() async {
    // call parent
    widget.onDelete();
    // fire
    try {
      await FireRources.deleteBlock(widget.deckId, task.id);
    } catch (exc) {
      debugPrint('? ERROR: on deleting task; $exc');
    }
  }

  Widget _buildTitle() => TextField(
    controller: _taskController.titleController,
    focusNode: _taskController.titleFocus,
    style: Styles.TEXT_UNINPUT,
    decoration: Decorations.INPUT_FIELD(
      padding: EdgeInsets.all(6.0),
      hintText: 'I have to do ...',
      hoverColor: Colours.DRIVE_AC,
      tipColor: Colours.DRIVE_UN,
    ),
    onEditingComplete: () => _taskController.titleFocus.unfocus(),
    onTapOutside: (event) => _taskController.titleFocus.unfocus(),
  );
  Widget _buildDescription() => TextFormField(
    controller: _taskController.descriptionController,
    focusNode: _taskController.descriptionFocus,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 4,
    style: Styles.TEXT_UNINPUT_MULTILINE,
    decoration: Decorations.INPUT_FIELD(
      padding: EdgeInsets.all(12.0),
      labelText: 'Description',
      hoverColor: Colours.DRIVE_AC,
      tipColor: Colours.DRIVE_UN,
    ),
    onTapOutside: (event) => _taskController.descriptionFocus.unfocus(),
  );
  Widget _buildDeadline() => SizedBox(
    width: 110.0,
    child: task.deadline != null
        ? TextButton(
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
            child: Text(task.deadline!.ddMMMyyyy, style: Styles.TEXT_UNINFO),
          )
        : IconButton(
            icon: Icon(TaskParameter.deadline.icon, color: Colours.INK_UN),
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
          ),
  );
  Widget _buildPoints() => PopupMenuButton<PointsTShirt>(
    tooltip: 'points',
    initialValue: task.points,
    icon: SizedBox(
      width: 40.0,
      child: Center(
        child: task.points != null
            ? Text(task.points!.label, style: Styles.TEXT_UNINFO)
            : Icon(TaskParameter.points.icon, color: Colours.INK_UN),
      ),
    ),
    itemBuilder: (context) => [
      for (final point in PointsTShirt.values)
        PopupMenuItem(
          height: 30.0,
          value: point,
          child: Center(child: Text(point.label)),
        ),
    ],
    constraints: const BoxConstraints.tightFor(),
    onSelected: (points) {
      _taskController.updatePoints(points);
    },
  );
  Widget _buildAssignee() => Wrap(
    alignment: WrapAlignment.center,
    runAlignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 8,
    runSpacing: 4,
    children: [
      const Text(
        'to',
        style: TextStyle(
          fontSize: 13,
          fontFamily: Fonts.RUBIK,
          fontWeight: FontWeight.w500,
        ),
      ),
      if (task.assignee.isEmpty)
        IconButton(
          icon: Icon(TaskParameter.assignee.icon, size: 15),
          onPressed: () =>
              showDialog<Set<String>?>(
                context: context,
                builder: (context) => ChipsGradialog(
                  selected: task.assignee.toSet(),
                  parameter: TaskParameter.assignee,
                  values: widget.members.values.toSet(),
                ),
              ).then((result) {
                if (result != null) _taskController.updateAssignee(result);
              }),
        ),
      for (final asign in task.assignee)
        TextButton(
          onPressed: () =>
              showDialog<Set<String>?>(
                context: context,
                builder: (context) => ChipsGradialog(
                  selected: task.assignee.toSet(),
                  parameter: TaskParameter.assignee,
                  values: widget.members.values.toSet(),
                ),
              ).then((result) {
                if (result != null) _taskController.updateAssignee(result);
              }),
          child: Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 3,
            children: [
              ProfileAvatar(profile: widget.members[asign]!, radius: 12.5),
              Text(widget.members[asign]!.name, style: Styles.TEXT_UN),
            ],
          ),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.5),
      child: ListenableBuilder(
        listenable: _taskController,
        builder: (context, child) => ExpansionTile(
          maintainState: true,
          expandedCrossAxisAlignment: CrossAxisAlignment.center,
          tilePadding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 0.0,
            bottom: 7.5,
          ),
          childrenPadding: const EdgeInsets.only(bottom: 7.5),
          collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(26)),
            side: BorderSide.none,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(26)),
            side: BorderSide.none,
          ),
          collapsedBackgroundColor: Colours.DRIVE,
          backgroundColor: Colours.MEDIUM,
          collapsedIconColor: Colours.INK_UN,
          iconColor: Colours.INK_UN,
          collapsedTextColor: Colours.DRIVE_UN,
          textColor: Colours.DRIVE_UN,
          leading: const Icon(
            Icons.drag_indicator_outlined,
            size: 17,
            color: Colours.INK,
          ),
          title: _buildTitle(),
          subtitle: _buildAssignee(),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_forever_rounded,
              size: 18,
              color: Colours.SHIFT,
              shadows: List.generate(
                20,
                (index) => const Shadow(blurRadius: 0.75, color: Colours.O),
              ),
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AcceptGradialog(
                icon: Icons.delete_sweep_rounded,
                message: 'This will permanently remove the task...',
                onAccept: () => delete(),
              ),
            ),
          ),
          children: [
            _buildDescription(),
            const SizedBox(height: 9.0),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [_buildPoints(), _buildDeadline()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
