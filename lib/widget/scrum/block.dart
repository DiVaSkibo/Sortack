import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/basics.dart';
import 'package:sortack/widget/dialogs.dart';

/// Scrum row class - advanced task block view for scrum methodology
class ScrumRow extends StatefulWidget {
  final String deckId, plankId;
  final AdvancedBlock task;
  final int order;
  final Map<String, UserProfile> members;
  final VoidCallback onDelete;

  ScrumRow({
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
  State<ScrumRow> createState() => _ScrumRowState();
}

class _ScrumRowState extends State<ScrumRow> {
  late final bool enabled = widget.task.enabled;
  late final AdvancedBlockController? _taskController;
  AdvancedBlock get task => enabled ? _taskController!.task : widget.task;

  @override
  void initState() {
    super.initState();
    if (enabled)
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
    _taskController?.dispose();
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

  Widget _buildOrder() => Center(
    child: enabled
        ? TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AcceptGradialog(
                icon: Icons.delete_sweep_rounded,
                message: 'Do you realy want to delete this task?...',
                onAccept: () => delete(),
              ),
            ),
            child: Text(
              '${widget.order + 1}',
              style: TextStyle(
                fontSize: 12,
                fontFamily: Fonts.RUBIK_MONO_ONE,
                color: Colours.INK_UN,
              ),
            ),
          )
        : Text(
            '${widget.order + 1}',
            style: TextStyle(
              fontSize: 12,
              fontFamily: Fonts.RUBIK_MONO_ONE,
              color: Colours.INK_UN,
            ),
          ),
  );
  Widget _buildTitle() => enabled
      ? TextField(
          controller: _taskController?.titleController,
          focusNode: _taskController?.titleFocus,
          style: Styles.TEXT_INPUT,
          decoration: Decorations.INPUT_FIELD(
            padding: EdgeInsets.zero,
            hintText: 'I have to do ...',
            hoverColor: Colours.CANVAS_AC,
            tipColor: Colours.INK_UN,
          ),
          onEditingComplete: () => _taskController?.titleFocus.unfocus(),
          onTapOutside: (event) => _taskController?.titleFocus.unfocus(),
        )
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 9.0),
          child: Text(task.title, style: Styles.TEXT_INPUT_DISABLED),
        );
  Widget _buildDescription() => enabled
      ? TextFormField(
          controller: _taskController?.descriptionController,
          focusNode: _taskController?.descriptionFocus,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 4,
          style: Styles.TEXT_INPUT_MULTILINE,
          decoration: Decorations.INPUT_FIELD(
            padding: EdgeInsets.zero,
            hintText: '...',
            hoverColor: Colours.CANVAS_AC,
            tipColor: Colours.INK_UN,
          ),
          onTapOutside: (event) => _taskController?.descriptionFocus.unfocus(),
        )
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 9.0),
          child: Text(task.description, style: Styles.TEXT_INPUT_MULTILINE),
        );
  Widget _buildDeadline() => Center(
    child: enabled
        ? task.deadline != null
              ? TextButton(
                  onPressed: () async {
                    DateTime? deadline = await showDatePicker(
                      context: context,
                      initialDate: task.deadline,
                      firstDate: DateTime(1800),
                      lastDate: DateTime(3000),
                    );
                    if (deadline != null) {
                      _taskController?.updateDeadline(deadline);
                    }
                  },
                  child: Text(
                    task.deadline!.ddMMMyyyy,
                    style: Styles.TEXT_INFO,
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.alarm_rounded, color: Colours.INK),
                  onPressed: () async {
                    DateTime? deadline = await showDatePicker(
                      context: context,
                      initialDate: task.deadline,
                      firstDate: DateTime(1800),
                      lastDate: DateTime(3000),
                    );
                    if (deadline != null) {
                      _taskController?.updateDeadline(deadline);
                    }
                  },
                )
        : task.deadline != null
        ? Text(task.deadline!.ddMMMyyyy, style: Styles.TEXT_INFO)
        : const Icon(Icons.alarm_rounded, color: Colours.INK_UN),
  );
  Widget _buildStatus() => enabled
      ? InkWell(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: task.status.colour,
            child: Center(
              child: Text(task.status.label, style: Styles.TEXT_UNINFO),
            ),
          ),
          onTap: () {
            var newStatus =
                Status.values[(task.status.index + 1) % Status.values.length];
            _taskController?.updateStatus(newStatus);
          },
        )
      : Container(
          width: double.infinity,
          height: double.infinity,
          color: task.status.colour,
          child: Center(
            child: Text(task.status.label, style: Styles.TEXT_UNINFO),
          ),
        );
  Widget _buildPriority() => Center(
    child: enabled
        ? PopupMenuButton<Priority>(
            tooltip: 'priority',
            initialValue: task.priority,
            icon: Icon(
              task.priority.icon,
              size: 26,
              color: task.priority.colour,
            ),
            itemBuilder: (context) => [
              for (final prior in Priority.values)
                PopupMenuItem(
                  height: 35.0,
                  value: prior,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 6,
                    children: [
                      Icon(prior.icon, size: 22, color: prior.colour),
                      Text(prior.label),
                    ],
                  ),
                ),
            ],
            constraints: const BoxConstraints.tightFor(),
            onSelected: (value) {
              _taskController?.updatePriority(value);
            },
          )
        : Icon(task.priority.icon, size: 26, color: task.priority.colour),
  );
  Widget _buildPoints() => Center(
    child: enabled
        ? PopupMenuButton<PointsTShirt>(
            tooltip: 'points',
            initialValue: task.points,
            icon: task.points != null
                ? Text(task.points!.label, style: Styles.TEXT_INFO)
                : const Icon(Icons.style_outlined, color: Colours.INK),
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
              _taskController?.updatePoints(points);
            },
          )
        : task.points != null
        ? Text(task.points!.label, style: Styles.TEXT_INFO)
        : const Icon(Icons.style_outlined, color: Colours.INK_UN),
  );
  Widget _buildAssignee() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        if (task.assignee.isEmpty)
          enabled
              ? IconButton(
                  icon: const Icon(
                    Icons.person_add_outlined,
                    size: 15,
                    color: Colours.INK,
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ChipsGradialog(
                      values: widget.members.values.toSet(),
                      selected: task.assignee.toSet(),
                      onPick: (assignee) => _taskController?.updateAssignee(
                        assignee as Set<String>,
                      ),
                    ),
                  ),
                )
              : const Icon(
                  Icons.person_add_outlined,
                  size: 15,
                  color: Colours.INK_UN,
                ),
        for (final asign in task.assignee)
          enabled
              ? TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ChipsGradialog(
                      values: widget.members.values.toSet(),
                      selected: task.assignee.toSet(),
                      onPick: (assignee) => _taskController?.updateAssignee(
                        assignee as Set<String>,
                      ),
                    ),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 3,
                    children: [
                      ProfileAvatar(
                        profile: widget.members[asign]!,
                        radius: 12.5,
                      ),
                      Text(widget.members[asign]!.name, style: Styles.TEXT),
                    ],
                  ),
                )
              : Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 3,
                  children: [
                    ProfileAvatar(
                      profile: widget.members[asign]!,
                      radius: 12.5,
                    ),
                    Text(widget.members[asign]!.name, style: Styles.TEXT),
                  ],
                ),
      ],
    ),
  );
  Widget _buildTags() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        if (task.tags.isEmpty)
          enabled
              ? IconButton(
                  icon: const Icon(
                    Icons.bookmark_add_outlined,
                    size: 15,
                    color: Colours.INK,
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ChipsGradialog(
                      values: Tag.values.toSet(),
                      selected: task.tags.toSet(),
                      onPick: (tags) =>
                          _taskController?.updateTags(tags as Set<Tag>),
                    ),
                  ),
                )
              : const Icon(
                  Icons.bookmark_add_outlined,
                  size: 15,
                  color: Colours.INK_UN,
                ),
        for (final tag in task.tags)
          InputChip(
            isEnabled: enabled,
            selected: true,
            label: Text(tag.label),
            color: WidgetStatePropertyAll(tag.colour),
            labelStyle: const TextStyle(
              fontSize: 10,
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: Colours.O,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ChipsGradialog(
                values: Tag.values.toSet(),
                selected: task.tags.toSet(),
                onPick: (tags) => _taskController?.updateTags(tags as Set<Tag>),
              ),
            ),
          ),
      ],
    ),
  );
  Widget _buildNotes() => enabled
      ? TextFormField(
          controller: _taskController?.notesController,
          focusNode: _taskController?.notesFocus,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 2,
          style: Styles.TEXT_INPUT_ITALIC,
          decoration: Decorations.INPUT_FIELD(
            padding: EdgeInsets.zero,
            hintText: '...',
            hoverColor: Colours.CANVAS_AC,
            tipColor: Colours.INK_UN,
          ),
          onTapOutside: (event) => _taskController?.notesFocus.unfocus(),
        )
      : Text(task.notes, style: Styles.TEXT_INPUT_ITALIC);

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      enabled: enabled,
      index: widget.order,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: Colours.GLOSS)),
          color: Colours.CANVAS,
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: _buildOrder()),
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
      ),
    );
  }
}
