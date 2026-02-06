import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/tool/_consts.dart';
import 'package:sortack/tool/_oop.dart';
import 'package:sortack/widget/_base.dart';

/// Kanban card widget - card with a task info
class KanbanCard extends StatefulWidget {
  final Task task;
  final void Function(Task what)? onDelete;

  const KanbanCard({super.key, required this.task, this.onDelete});

  KanbanCard.from({
    super.key,
    required String title,
    String? description,
    TaskPointsTShirt? points,
    this.onDelete,
  }) : task = Task(title: title, description: description, points: points);

  @override
  State<KanbanCard> createState() => _KanbanCardState();
}

class _KanbanCardState extends State<KanbanCard> {
  late Task task = widget.task;
  late final void Function(Task what)? onDelete = widget.onDelete;
  late final _taskController = TaskController(task, setState: setState);

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
        task.points = value;
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
    return ExpansionTile(
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
                  if (onDelete != null) onDelete!(task);
                  Navigator.of(context).pop();
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
    );
  }
}

/// Kanban column class - list of tasks of a particular status
class KanbanColumn {
  String status;
  final List<Task> tasks;
  Color? color;
  final Function(void Function()) setState;
  final TextEditingController _statusController;
  final FocusNode _statusFocus = FocusNode();

  KanbanColumn({
    required this.status,
    required this.tasks,
    this.color,
    required this.setState,
  }) : _statusController = TextEditingController(text: status) {
    _statusFocus.addListener(() {
      if (!_statusFocus.hasFocus)
        setState(() {
          status = _statusController.text;
          debugPrint(
            'Column status:\n"$status"\n\t("${_statusController.text}")',
          );
        });
    });
  }

  final _filter = {};

  void dispose() {
    _statusController.dispose();
    _statusFocus.dispose();
  }

  void push(Task what, {bool front = false}) {
    //debugPrint('${what.toString()} is pushed ${front ? 'front' : 'back'} to $status');
    if (front)
      tasks.insert(0, what);
    else
      tasks.add(what);
  }

  void pop(Task what) {
    //debugPrint('${what.toString()} is poped from $status');
    tasks.remove(what);
    //debugPrint('$status: ${tasks.map((task) => task.title).toString()}');
  }

  void insert(Task what, int where) {
    //debugPrint('${what.toString()} is inserted at $where');
    tasks.insert(where, what);
    //debugPrint('$status: ${tasks.map((task) => task.title).toString()}');
  }

  void swap(int oldItemIndex, int newItemIndex) {
    if (oldItemIndex == newItemIndex) return;
    var temp = tasks[oldItemIndex];
    tasks[oldItemIndex] = tasks[newItemIndex];
    tasks[newItemIndex] = temp;
  }

  void sort({TaskParameters? by}) {
    by != null ? tasks.sort((a, b) => a.compareTo(b, by: by)) : tasks.sort();
  }

  void filter({TaskParameters? by, dynamic from, dynamic to}) {
    _filter['by'] = by;
    _filter['from'] = from;
    _filter['to'] = to;
  }

  DragAndDropList build() {
    var filteredTasks = _filter['by'] != null
        ? tasks
              .where(
                (x) => x.testInterval(
                  by: _filter['by'],
                  from: _filter['from'],
                  to: _filter['to'],
                ),
              )
              .toList()
        : tasks;
    return DragAndDropList(
      verticalAlignment: CrossAxisAlignment.center,
      decoration: Decorations.SURFACE_BOX,
      header:
          //Text(status, style: Styles.columnText(color: color)),
          TextField(
            controller: _statusController,
            focusNode: _statusFocus,
            textAlign: TextAlign.center,
            onEditingComplete: () => _statusFocus.unfocus(),
            onTapOutside: (event) => _statusFocus.unfocus(),
            style: Styles.columnText(color: color),
            decoration: Decorations.columnInput(),
          ),
      contentsWhenEmpty: Icon(unicon(), size: 30),
      children: List.generate(
        filteredTasks.length,
        (index) => DragAndDropItem(
          child: KanbanCard(
            key: ValueKey(filteredTasks[index].title),
            task: filteredTasks[index],
            onDelete: (what) => setState(() => pop(what)),
          ),
        ),
      ),
    );
  }
}

/// Kanban board widget - list of columns
class KanbanBoard extends StatefulWidget {
  KanbanBoard({super.key});

  final _KanbanBoardState _kanbanBoardState = _KanbanBoardState();

  void push(KanbanColumn what) => _kanbanBoardState.push(what);
  void pop(KanbanColumn what) => _kanbanBoardState.pop(what);
  void insert(KanbanColumn what, int where) =>
      _kanbanBoardState.insert(what, where);
  void newTask() => _kanbanBoardState.newTask();
  void sort({TaskParameters? by}) => _kanbanBoardState.sort(by: by);
  void filter({TaskParameters? by, dynamic from, dynamic to}) =>
      _kanbanBoardState.filter(by: by, from: from, to: to);

  @override
  State<KanbanBoard> createState() => _kanbanBoardState;
}

class _KanbanBoardState extends State<KanbanBoard> {
  late final List<KanbanColumn> columns = <KanbanColumn>[
    KanbanColumn(
      status: 'To Do',
      color: Colours.NOTOK,
      tasks: <Task>[
        Task(
          title: 'Database',
          description: 'Architecture and build database using Firebase',
          points: TaskPointsTShirt.XL,
        ),
        Task(
          title: 'Search system',
          description:
              'Search for available libraries for search system\nIf nothing, make by ourself',
          points: TaskPointsTShirt.L,
        ),
      ],
      setState: setState,
    ),
    KanbanColumn(
      status: 'In Progress',
      color: Colours.INOK,
      tasks: <Task>[
        Task(
          title: 'Sign In page',
          description: 'Create sign in page according to design in Figma',
          points: TaskPointsTShirt.S,
        ),
      ],
      setState: setState,
    ),
    KanbanColumn(
      status: 'Done',
      color: Colours.OK,
      tasks: <Task>[
        Task(
          title: 'Sign In page design',
          description: 'Design sign in page using Figma',
          points: TaskPointsTShirt.L,
        ),
        Task(title: 'What', description: 'What actually do'),
        Task(
          title: 'Who',
          description: 'Who actually do',
          points: TaskPointsTShirt.XXL,
        ),
      ],
      setState: setState,
    ),
  ];
  final ScrollController _columnsScrollController = ScrollController();

  @override
  void dispose() {
    _columnsScrollController.dispose();
    for (final KanbanColumn column in columns) column.dispose();
    super.dispose();
  }

  void push(KanbanColumn what, {bool front = false}) {
    //debugPrint('${what.toString()} is pushed ${front ? 'front' : 'back'} to $this');
    var column = KanbanColumn(
      status: what.status,
      tasks: [],
      color: what.color,
      setState: setState,
    );
    setState(() {
      if (front)
        columns.insert(0, column);
      else
        columns.add(column);
    });
  }

  void pop(KanbanColumn what) {
    //debugPrint('${what.toString()} is poped from $this');
    setState(() {
      columns.remove(what);
    });
    //debugPrint('$this: ${columns.map((column) => column.tasks).toString()}');
  }

  void insert(KanbanColumn what, int where) {
    //debugPrint('${what.toString()} is inserted at $where');
    var column = KanbanColumn(
      status: what.status,
      tasks: [],
      color: what.color,
      setState: setState,
    );
    setState(() {
      columns.insert(where, column);
    });
    //debugPrint('$this: ${columns.map((column) => column.tasks).toString()}');
  }

  void swap(int oldListIndex, int newListIndex) {
    if (oldListIndex == newListIndex) return;
    var temp = columns[oldListIndex];
    columns[oldListIndex] = columns[newListIndex];
    columns[newListIndex] = temp;
  }

  void newTask() {
    setState(() {
      columns.first.push(Task(), front: true);
    });
  }

  void sort({TaskParameters? by}) {
    setState(() {
      for (var column in columns) column.sort(by: by);
    });
  }

  void filter({TaskParameters? by, dynamic from, dynamic to}) {
    setState(() {
      for (var column in columns) column.filter(by: by, from: from, to: to);
    });
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
        children: columns.map((column) => column.build()).toList(),
        onItemReorder:
            (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
              if (oldListIndex == newListIndex) {
                setState(() {
                  columns[newListIndex].swap(oldItemIndex, newItemIndex);
                });
              } else {
                var task = columns[oldListIndex].tasks.elementAt(oldItemIndex);
                setState(() {
                  columns[oldListIndex].pop(task);
                  columns[newListIndex].insert(task, newItemIndex);
                });
              }
            },
        onListReorder: (oldListIndex, newListIndex) {
          setState(() {
            swap(oldListIndex, newListIndex);
          });
        },
      ),
    );
  }
}
