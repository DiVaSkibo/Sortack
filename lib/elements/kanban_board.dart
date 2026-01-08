import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/tool/_constants.dart';
import 'package:sortack/tool/_style.dart';
import 'package:sortack/elements/_base.dart';
import 'package:sortack/elements/kanban_card.dart';
import 'package:sortack/elements/kanban_column.dart';

class KanbanBoard extends StatefulWidget {
  const KanbanBoard({super.key});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  final List<Map<String, dynamic>> columns = [
    {
      'title': 'To Do',
      'tasks': ['Database architecture', 'Search system'],
    },
    {
      'title': 'In Progress',
      'tasks': ['Sign In page', 'Unit Tests'],
    },
    {
      'title': 'Done',
      'tasks': ['Design system', 'Requirements'],
    },
  ];
  final List<KanbanColumn> kanbanColumns = <KanbanColumn>[
    KanbanColumn(
      status: 'To Do',
      color: Colors.redAccent,
      tasks: <KanbanCard>[
        KanbanCard(
          title: 'Database',
          description: 'Architecture and build database using Firebase',
          points: PointsTShirt.XL,
        ),
        KanbanCard(
          title: 'Search system',
          description:
              'Search for available libraries for search system\nIf nothing, make by ourself',
          points: PointsTShirt.L,
        ),
      ],
    ),
    KanbanColumn(
      status: 'In Progress',
      color: Colors.yellowAccent,
      tasks: [
        KanbanCard(
          title: 'Sign In page',
          description: 'Create sign in page according to design in Figma',
          points: PointsTShirt.S,
        ),
      ],
    ),
    KanbanColumn(
      status: 'Done',
      color: Colors.greenAccent,
      tasks: [
        KanbanCard(
          title: 'Sign In page design',
          description: 'Design sign in page using Figma',
          points: PointsTShirt.L,
        ),
        KanbanCard(title: 'What', description: 'What actually do'),
        KanbanCard(
          title: 'Who',
          description: 'Who actually do',
          points: PointsTShirt.XXL,
          onDelete: (what) {},
        ),
      ],
    ),
  ];
  final _task = {};

  DragAndDropList _buildList(int colIndex) {
    var columnData = columns[colIndex];
    List<String> tasks = columnData['tasks'];

    return DragAndDropList(
      // Хедер колонки (Твій заголовок To Do / In Progress)
      header: Container(
        padding: const EdgeInsets.all(10),
        // Твій стиль заголовка
        child: Text(
          columnData['title'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),

      // Налаштування вигляду самої колонки
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Легкий фон колонки
        borderRadius: BorderRadius.circular(15),
      ),

      // Список карток всередині
      children: List.generate(tasks.length, (taskIndex) {
        return DragAndDropItem(
          // ВАЖЛИВО: Сюди вставляй свій віджет KanbanCard!
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            // Замість Container нижче встав свій: KanbanCard(...)
            child: Card(
              color: const Color(0xFF1E3C42), // Колір твоєї картки
              child: ListTile(
                title: Text(
                  tasks[taskIndex],
                  style: const TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.circle,
                  color: Colors.yellow,
                ), // Твій циліндр
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DragAndDropLists(
      axis: Axis.horizontal,
      listWidth: 300,
      listDraggingWidth: 300,
      listPadding: const EdgeInsets.all(8.0),
      itemDragOnLongPress: false,
      listDragOnLongPress: true,
      children: List.generate(columns.length, (index) => _buildList(index)),
      onItemReorder:
          (
            int oldItemIndex,
            int oldListIndex,
            int newItemIndex,
            int newListIndex,
          ) {
            setState(() {
              var movedTask = columns[oldListIndex]['tasks'].removeAt(
                oldItemIndex,
              );
              columns[newListIndex]['tasks'].insert(newItemIndex, movedTask);
            });
          },
      onListReorder: (int oldListIndex, int newListIndex) {
        setState(() {
          var movedList = columns.removeAt(oldListIndex);
          columns.insert(newListIndex, movedList);
        });
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Kanban'),
  //       leading: IconButton(
  //         onPressed: () => Navigator.pop(context),
  //         icon: Icon(Icons.keyboard_return_rounded),
  //       ),
  //       actions: <Widget>[
  //         Builder(
  //           builder: (context) => IconButton(
  //             onPressed: Scaffold.of(context).openEndDrawer,
  //             icon: Icon(Icons.blur_on_rounded),
  //           ),
  //         ),
  //       ],
  //       flexibleSpace: Icon(
  //         Icons.view_week_rounded,
  //         color: Colours.FRONT,
  //       ), // view_week_rounded amp_stories_rounded
  //     ),
  //     endDrawer: Container(
  //       decoration: const BoxDecoration(
  //         gradient: RadialGradient(
  //           center: Alignment.centerRight,
  //           radius: 1,
  //           colors: [Colours.FRONT, Colours.BACK],
  //         ),
  //       ),
  //       child: Drawer(
  //         child: ListView(
  //           children: <Widget>[
  //             const DrawerHeader(
  //               decoration: BoxDecoration(
  //                 gradient: RadialGradient(
  //                   radius: 1,
  //                   colors: [Colours.BACK, Colours.UNFRONT],
  //                 ),
  //               ),
  //               padding: EdgeInsetsGeometry.all(0),
  //               child: Icon(Icons.blur_on_rounded, size: 75),
  //             ),
  //             TextButton.icon(
  //               onPressed: () => Navigator.pop(context),
  //               icon: Icon(Icons.explore_rounded),
  //               label: Text('Explore'),
  //             ),
  //             TextButton.icon(
  //               onPressed: () => Navigator.pop(context),
  //               icon: Icon(Icons.fort_rounded),
  //               label: Text('Fort'),
  //             ),
  //             TextButton.icon(
  //               onPressed: () => Navigator.pop(context),
  //               icon: Icon(Icons.format_paint_rounded),
  //               label: Text('Format paint'),
  //             ),
  //             TextButton.icon(
  //               onPressed: () => Navigator.pop(context),
  //               icon: Icon(Icons.airplane_ticket_rounded),
  //               label: Text('Airplane ticket'),
  //             ),
  //             TextButton.icon(
  //               onPressed: () => Navigator.pop(context),
  //               icon: Icon(Icons.church_rounded),
  //               label: Text('Church'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     body: Container(
  //       width: MediaQuery.of(context).size.width,
  //       height: MediaQuery.of(context).size.height,
  //       decoration: const BoxDecoration(gradient: Gradients.GROUND),
  //       child: SingleChildScrollView(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           spacing: 25,
  //           children: kanbanColumns,
  //         ),
  //       ),
  //     ),
  //     floatingActionButton: IconButton(
  //       onPressed: () => showDialog(
  //         context: context,
  //         builder: (context) => FlowDialog.task(
  //           purpose: TaskFlowPurposes.create,
  //           onTitleChanged: (value) {
  //             _task['title'] = value;
  //           },
  //           onDescriptionChanged: (value) {
  //             _task['description'] = value;
  //           },
  //           onPointsChanged: (value) {
  //             _task['points'] = value;
  //           },
  //           onCancel: Navigator.of(context).pop,
  //           onCreate: () {
  //             if (!_task.containsKey('title')) return;
  //             kanbanColumns.first.push(
  //               KanbanCard(
  //                 title: _task['title'],
  //                 description: _task['description'],
  //                 points: _task['points'],
  //               ),
  //             );
  //             _task.clear();
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ),
  //       icon: Icon(Icons.add_task_rounded),
  //     ),
  //   );
  //}
}
