import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/widget/basics.dart';

/// Kanban card widget - task block view
class KanbanCard extends StatefulWidget {
  final TaskBlock task;
  final Function(TaskBlock) onDelete;

  const KanbanCard({super.key, required this.task, required this.onDelete});

  @override
  State<KanbanCard> createState() => _KanbanCardState();
}

class _KanbanCardState extends State<KanbanCard> {
  late final TaskBlockController _taskController;
  TaskBlock get task => _taskController.task;

  @override
  void initState() {
    super.initState();
    _taskController = TaskBlockController(widget.task);
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  TextField buildTitleField() => TextField(
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
  TextFormField buildDescriptionField() => TextFormField(
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
  PopupMenuButton buildPointsField() => PopupMenuButton<TaskPointsTShirt>(
    tooltip: 'points',
    initialValue: task.points,
    child: Text(task.points != null ? task.points!.name.toString() : '?'),
    itemBuilder: (context) => TaskPointsTShirt.values
        .map((value) => PopupMenuItem(value: value, child: Text(value.name)))
        .toList(),
    onSelected: (TaskPointsTShirt value) {
      setState(() {
        _taskController.updatePoints(value);
      });
    },
  );
  TextFormField buildNotesField() => TextFormField(
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
        title: buildTitleField(),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AcceptDialog(
                  message: 'Do you realy want to delete this task?...',
                  onCancel: Navigator.of(context).pop,
                  onAccept: () {
                    Navigator.of(context).pop();
                    widget.onDelete(task);
                  },
                  icon: Icons.remove_rounded,
                ),
              ),
              icon: Icon(Icons.remove_rounded),
            ),
          ],
        ),
        trailing: buildPointsField(),
        children: [buildDescriptionField(), buildNotesField()],
      ),
    );
  }
}

/// Kanban column class - titled task plank view with Kanban card children
final class KanbanColumn {
  final TitledTaskPlank tasks;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  List<TaskBlock> get visibleTasks => tasks.visibleBlocks;
  final ColoredTitleController _coloredTitleController;

  KanbanColumn({
    String? title,
    Color? color,
    required this.tasks,
    required this.onChanged,
    required this.onDelete,
  }) : _coloredTitleController = ColoredTitleController(
         initialTitle: title,
         initialColor: color,
       );

  void dispose() {
    _coloredTitleController.dispose();
  }

  DragAndDropList build() {
    return DragAndDropList(
      verticalAlignment: CrossAxisAlignment.center,
      decoration: Decorations.SURFACE_BOX,
      header: ListenableBuilder(
        listenable: _coloredTitleController,
        builder: (context, child) => TextField(
          controller: _coloredTitleController.titleController,
          focusNode: _coloredTitleController.titleFocus,
          textAlign: TextAlign.center,
          onEditingComplete: () {
            _coloredTitleController.titleFocus.unfocus();
            tasks.title = _coloredTitleController.title;
          },
          onTapOutside: (event) {
            _coloredTitleController.titleFocus.unfocus();
            tasks.title = _coloredTitleController.title;
          },
          style: Styles.columnText(color: _coloredTitleController.color),
          decoration: Decorations.columnInput(),
        ),
      ),
      contentsWhenEmpty: Icon(unicon(), size: 30),
      children: List.generate(
        visibleTasks.length,
        (index) => DragAndDropItem(
          child: KanbanCard(
            key: ValueKey(visibleTasks[index].title),
            task: visibleTasks[index],
            onDelete: (what) => tasks.pop(what),
          ),
        ),
      ),
    );
  }
}

/// Kanban board widget - task board view with Kanban column children
class KanbanBoard extends StatefulWidget {
  final TaskBoard columns;

  const KanbanBoard({super.key, required this.columns});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  late final TaskBoard board = widget.columns;
  final ScrollController _columnsScrollController = ScrollController();

  @override
  void dispose() {
    _columnsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _columnsScrollController,
      scrollbarOrientation: ScrollbarOrientation.top,
      child: DragAndDropLists(
        axis: Axis.horizontal,
        listWidth: MediaQuery.of(context).size.width / 3,
        listPadding: const EdgeInsets.all(8.0),
        lastItemTargetHeight: 200,
        // itemDragOnLongPress: false,
        // listDragOnLongPress: false,
        scrollController: _columnsScrollController,
        children: board.planks
            .map(
              (plank) => KanbanColumn(
                title: plank.title,
                color: plank.color,
                tasks: plank,
                onChanged: () {},
                onDelete: () {},
              ).build(),
            )
            .toList(),
        onItemReorder:
            (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
              if (oldListIndex == newListIndex) {
                setState(() {
                  board[newListIndex].move(oldItemIndex, newItemIndex);
                });
              } else {
                var task = board[oldListIndex].blocks[oldItemIndex];
                setState(() {
                  board[oldListIndex].pop(task);
                  board[newListIndex].insert(task, newItemIndex);
                });
              }
            },
        onListReorder: (oldListIndex, newListIndex) {
          setState(() {
            board.move(oldListIndex, newListIndex);
          });
        },
      ),
    );
  }
}
