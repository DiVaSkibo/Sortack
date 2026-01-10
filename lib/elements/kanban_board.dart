import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/tool/_constants.dart';
import 'package:sortack/tool/_style.dart';
import 'package:sortack/elements/_base.dart';
import 'package:sortack/elements/kanban_card.dart';
//import 'package:sortack/elements/kanban_column.dart';

class KanbanBoard extends StatefulWidget {
  const KanbanBoard({super.key});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  final List<Map<String, dynamic>> columns = [
    {
      'title': 'To Do',
      'tasks': [
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
    },
    {
      'title': 'In Progress',
      'tasks': [
        KanbanCardData(
          title: 'Sign In page',
          description: 'Create sign in page according to design in Figma',
          points: PointsTShirt.S,
        ),
      ],
    },
    {
      'title': 'Done',
      'tasks': [
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
    },
  ];
  // final List<KanbanColumn> columns = <KanbanColumn>[
  //   KanbanColumn(
  //     status: 'To Do',
  //     color: Colours.NOTOK,
  //     tasks: <KanbanCardData>[
  //       KanbanCardData(
  //         title: 'Database',
  //         description: 'Architecture and build database using Firebase',
  //         points: PointsTShirt.XL,
  //       ),
  //       KanbanCardData(
  //         title: 'Search system',
  //         description:
  //             'Search for available libraries for search system\nIf nothing, make by ourself',
  //         points: PointsTShirt.L,
  //       ),
  //     ],
  //   ),
  //   KanbanColumn(
  //     status: 'In Progress',
  //     color: Colours.INOK,
  //     tasks: <KanbanCardData>[
  //       KanbanCardData(
  //         title: 'Sign In page',
  //         description: 'Create sign in page according to design in Figma',
  //         points: PointsTShirt.S,
  //       ),
  //     ],
  //   ),
  //   KanbanColumn(
  //     status: 'Done',
  //     color: Colours.OK,
  //     tasks: <KanbanCardData>[
  //       KanbanCardData(
  //         title: 'Sign In page design',
  //         description: 'Design sign in page using Figma',
  //         points: PointsTShirt.L,
  //       ),
  //       KanbanCardData(title: 'What', description: 'What actually do'),
  //       KanbanCardData(
  //         title: 'Who',
  //         description: 'Who actually do',
  //         points: PointsTShirt.XXL,
  //       ),
  //     ],
  //   ),
  // ];
  final _task = {};

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
      //children: columns,
      children: List.generate(
        columns.length,
        (index) => DragAndDropList(
          header: Text(columns[index]['title']),
          children: List.generate(
            columns[index]['tasks'].length,
            (taskIndex) => DragAndDropItem(
              child: KanbanCard(
                key: ValueKey(columns[index]['tasks'][taskIndex].title),
                data: columns[index]['tasks'][taskIndex],
              ),
            ),
          ),
        ),
      ),
      onItemReorder: (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
        setState(() {
          // var data = columns[oldListIndex].tasks.elementAt(oldItemIndex);
          // columns[oldListIndex].pop(data);
          // //debugPrint(task.toString());
          // columns[newListIndex].insert(data, newItemIndex);
          // columns[newListIndex].tasks.insert(newItemIndex, task);
          var movedTask = columns[oldListIndex]['tasks'].removeAt(oldItemIndex);
          debugPrint('${columns[oldListIndex]['title']} - ${movedTask.title}');
          columns[newListIndex]['tasks'].insert(newItemIndex, movedTask);
          debugPrint('${columns[newListIndex]['title']} + ${movedTask.title}');
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
