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
    onEditingComplete: () => _taskController.titleFocus.unfocus(),
    onTapOutside: (event) => _taskController.titleFocus.unfocus(),
    style: Styles.TEXT_UNINPUT,
    decoration: Decorations.INPUT_FIELD(
      padding: EdgeInsets.all(6.0),
      hintText: 'I have to do ...',
      hoverColor: Colours.DRIVE_AC,
      tipColor: Colours.DRIVE_UN,
    ),
  );
  Widget _buildDescription() => TextFormField(
    controller: _taskController.descriptionController,
    focusNode: _taskController.descriptionFocus,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 4,
    onTapOutside: (event) => _taskController.descriptionFocus.unfocus(),
    style: Styles.TEXT_UNINPUT_MULTILINE,
    decoration: Decorations.INPUT_FIELD(
      padding: EdgeInsets.all(12.0),
      labelText: 'Description',
      hoverColor: Colours.DRIVE_AC,
      tipColor: Colours.DRIVE_UN,
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
            : const Icon(Icons.style_outlined, color: Colours.INK_UN),
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
            icon: const Icon(Icons.alarm_rounded, color: Colours.INK_UN),
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
          icon: const Icon(Icons.person_add_outlined, size: 15),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ChipsGradialog(
              values: widget.members.values.toSet(),
              selected: task.assignee.toSet(),
              onPick: (assignee) =>
                  _taskController.updateAssignee(assignee as Set<String>),
            ),
          ),
        ),
      for (final asign in task.assignee)
        TextButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ChipsGradialog(
              values: widget.members.values.toSet(),
              selected: task.assignee.toSet(),
              onPick: (assignee) =>
                  _taskController.updateAssignee(assignee as Set<String>),
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
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
                (index) => Shadow(blurRadius: 0.75, color: Colours.O),
              ),
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AcceptGradialog(
                icon: Icons.delete_sweep_rounded,
                message: 'Do you realy want to delete this task?...',
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
