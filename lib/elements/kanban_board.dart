import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/tool/_constants.dart';
import 'package:sortack/tool/_style.dart';
import 'package:sortack/elements/_base.dart';
import 'package:sortack/elements/kanban_card.dart';
import 'package:sortack/elements/kanban_column.dart';

class KanbanBoard extends StatefulWidget {
  KanbanBoard({super.key});

  final _KanbanBoardState _kanbanBoardState = _KanbanBoardState();

  FlowDialog buildFlowDialog() => _kanbanBoardState.buildFlowDialog();

  @override
  State<KanbanBoard> createState() => _kanbanBoardState;
}

class _KanbanBoardState extends State<KanbanBoard> {
  final List<KanbanColumn> columns = <KanbanColumn>[
    KanbanColumn(
      status: 'To Do',
      color: Colours.NOTOK,
      tasks: <KanbanCardData>[
        KanbanCardData(
          title: 'Database',
          description: 'Architecture and build database using Firebase',
          points: PointsTShirt.XL,
        ),
        KanbanCardData(
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
      tasks: <KanbanCardData>[
        KanbanCardData(
          title: 'Sign In page',
          description: 'Create sign in page according to design in Figma',
          points: PointsTShirt.S,
        ),
      ],
    ),
    KanbanColumn(
      status: 'Done',
      color: Colours.OK,
      tasks: <KanbanCardData>[
        KanbanCardData(
          title: 'Sign In page design',
          description: 'Design sign in page using Figma',
          points: PointsTShirt.L,
        ),
        KanbanCardData(title: 'What', description: 'What actually do'),
        KanbanCardData(
          title: 'Who',
          description: 'Who actually do',
          points: PointsTShirt.XXL,
        ),
      ],
    ),
  ];
  final _task = {};

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
          KanbanCardData(
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
    return DragAndDropLists(
      axis: Axis.horizontal,
      listWidth: 300,
      listDraggingWidth: 300,
      listPadding: const EdgeInsets.all(8.0),
      itemDragOnLongPress: false,
      listDragOnLongPress: false,
      children: columns.map((column) => column.build()).toList(),
      onItemReorder: (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
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
    );
  }
}
