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
    PointsTShirt? points,
    this.onDelete,
  }) : task = Task(title: title, description: description, points: points);

  @override
  State<KanbanCard> createState() => _KanbanCardState();
}

class _KanbanCardState extends State<KanbanCard> {
  late Task task = widget.task;
  late final void Function(Task what)? onDelete = widget.onDelete;
  late final _controllers = <String, TextEditingController>{};
  final _last = {};

  @override
  void initState() {
    super.initState();
    _controllers['title'] = TextEditingController(text: task.title);
    _controllers['description'] = TextEditingController(text: task.description);
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

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
      title: Text(task.title),
      subtitle: task.description != null ? Text(task.description!) : null,
      trailing: Text(task.points != null ? task.points!.name.toString() : '?'),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: TaskParameters.values
              .map((value) => Icon(value.icon(), color: Colours.CENTER))
              .toList(),
        ),
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
    );
  }
}

/// Kanban column class - list of tasks of a particular status
class KanbanColumn {
  String status;
  final List<Task> tasks;
  Color? color;
  final Function()? onChanged;

  KanbanColumn({
    required this.status,
    required this.tasks,
    this.color,
    this.onChanged,
  });

  final _filter = {};

  void setState(void Function() fn) {
    fn();
    if (onChanged != null) onChanged!();
  }

  void push(Task what) {
    //debugPrint('${what.toString()} is pushed to $status');
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
      decoration: BoxDecoration(
        gradient: Gradients.SURFACE,
        borderRadius: BorderRadius.circular(15),
      ),
      header: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
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

  void sort({TaskParameters? by}) => _kanbanBoardState.sort(by: by);
  void filter({TaskParameters? by, dynamic from, dynamic to}) =>
      _kanbanBoardState.filter(by: by, from: from, to: to);

  TasksetDialog buildTasksetDialog() => _kanbanBoardState.buildTasksetDialog();

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
          points: PointsTShirt.XL,
        ),
        Task(
          title: 'Search system',
          description:
              'Search for available libraries for search system\nIf nothing, make by ourself',
          points: PointsTShirt.L,
        ),
      ],
      onChanged: () => setState(() {}),
    ),
    KanbanColumn(
      status: 'In Progress',
      color: Colours.INOK,
      tasks: <Task>[
        Task(
          title: 'Sign In page',
          description: 'Create sign in page according to design in Figma',
          points: PointsTShirt.S,
        ),
      ],
      onChanged: () => setState(() {}),
    ),
    KanbanColumn(
      status: 'Done',
      color: Colours.OK,
      tasks: <Task>[
        Task(
          title: 'Sign In page design',
          description: 'Design sign in page using Figma',
          points: PointsTShirt.L,
        ),
        Task(title: 'What', description: 'What actually do'),
        Task(
          title: 'Who',
          description: 'Who actually do',
          points: PointsTShirt.XXL,
        ),
      ],
      onChanged: () => setState(() {}),
    ),
  ];
  final ScrollController _columnsScrollController = ScrollController();

  @override
  void dispose() {
    _columnsScrollController.dispose();
    super.dispose();
  }

  void swap(int oldListIndex, int newListIndex) {
    if (oldListIndex == newListIndex) return;
    var temp = columns[oldListIndex];
    columns[oldListIndex] = columns[newListIndex];
    columns[newListIndex] = temp;
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

  TasksetDialog buildTasksetDialog() => TasksetDialog.create(
    onCancel: Navigator.of(context).pop,
    onAccept: (task) {
      if (task.title.isEmpty) return;
      columns.first.push(task);
      Navigator.of(context).pop();
    },
  );

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
        itemDragOnLongPress: false,
        listDragOnLongPress: false,
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
