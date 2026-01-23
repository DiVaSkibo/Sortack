import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/tool/_constants.dart';
import 'package:sortack/tool/_classes.dart';
import 'package:sortack/tool/_style.dart';
import 'package:sortack/elements/_base.dart';
import 'package:sortack/elements/kanban_column.dart';

class KanbanBoard extends StatefulWidget {
  KanbanBoard({super.key});

  final _KanbanBoardState _kanbanBoardState = _KanbanBoardState();

  void sort({TaskParameters? by}) => _kanbanBoardState.sort(by: by);
  void filter({TaskParameters? by, dynamic from, dynamic to}) =>
      _kanbanBoardState.filter(by: by, from: from, to: to);

  FlowDialog buildFlowDialog() => _kanbanBoardState.buildFlowDialog();

  @override
  State<KanbanBoard> createState() => _kanbanBoardState;
}

class _KanbanBoardState extends State<KanbanBoard> {
  final List<KanbanColumn> columns = <KanbanColumn>[
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
    ),
  ];
  final ScrollController _columnsScrollController = ScrollController();
  final _task = {};

  @override
  void dispose() {
    _columnsScrollController.dispose();
    super.dispose();
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

  FlowDialog buildFlowDialog() => FlowDialog.task(
    purpose: TaskFlowPurposes.create,
    onTitleChanged: (value) {
      _task['title'] = value;
    },
    onDescriptionChanged: (value) {
      _task['description'] = value;
    },
    onPointsChanged: (value) {
      _task['points'] = value;
    },
    onCancel: Navigator.of(context).pop,
    onCreate: () {
      if (!_task.containsKey('title')) return;
      setState(() {
        columns.first.push(
          Task(
            title: _task['title'],
            description: _task['description'],
            points: _task['points'],
          ),
        );
      });
      _task.clear();
      Navigator.of(context).pop();
    },
  );

  @override
  Widget build(BuildContext context) {
    //   SingleChildScrollView(
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       spacing: 25,
    //       children: columns,
    //     ),
    //   );
    return Scrollbar(
      controller: _columnsScrollController,
      scrollbarOrientation: ScrollbarOrientation.top,
      child: DragAndDropLists(
        axis: Axis.horizontal,
        listWidth: 450, // MediaQuery.of(context).size.width / 3,
        listPadding: const EdgeInsets.all(8.0),
        lastItemTargetHeight: 200,
        itemDragOnLongPress: false,
        listDragOnLongPress: false,
        scrollController: _columnsScrollController,
        children: columns.map((column) => column.build()).toList(),
        onItemReorder:
            (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
              setState(() {
                var data = columns[oldListIndex].tasks.elementAt(oldItemIndex);
                columns[oldListIndex].pop(data);
                columns[newListIndex].insert(data, newItemIndex);
              });
            },
        onListReorder: (oldListIndex, newListIndex) {
          setState(() {
            columns.insert(newListIndex, columns.removeAt(oldListIndex));
          });
        },
      ),
    );
  }
}
