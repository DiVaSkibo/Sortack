import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/tool/_style.dart';
import 'package:sortack/elements/kanban_card.dart';

class KanbanColumn extends DragAndDropList {
  String status;
  final List<KanbanCardData> tasks;
  //late final List<KanbanCard> tasks;
  Color? color;

  KanbanColumn({required this.status, required this.tasks, this.color})
    // : tasks = tasks
    //       .map((data) => KanbanCard(data: data, onDelete: (task) => pop(task)))
    //       .toList(),
    : super(
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
        children: List.generate(
          tasks.length,
          (index) => DragAndDropItem(
            child: KanbanCard(
              data: tasks[index],
              onDelete: (what) => {},
            ), //pop()),
          ),
        ),
        // children: tasks
        //     .map(
        //       (data) => DragAndDropItem(
        //         child: KanbanCard(data: data, onDelete: (what) => {}), //pop()),
        //       ),
        //     )
        //     .toList(),
      );

  void push(KanbanCardData what) {
    debugPrint('${what.toString()} is pushed to $status');
    tasks.add(
      what,
      // KanbanCard(
      //   title: what.title,
      //   description: what.description,
      //   points: what.points,
      //   onDelete: (task) => pop(task),
      // ),
    );
  }

  void pop(KanbanCardData what) {
    debugPrint('${what.toString()} is poped from $status');
    tasks.remove(what);
    debugPrint('$status: ${tasks.map((task) => task.title).toString()}');
  }

  void insert(KanbanCardData what, int where) {
    debugPrint('${what.toString()} is inserted at $where');
    tasks.insert(
      where,
      what,
      // KanbanCard(
      //   title: what.title,
      //   description: what.description,
      //   points: what.points,
      //   onDelete: (task) => pop(task),
      // ),
    );
    debugPrint('or isn`t?');
    debugPrint('$status: ${tasks.map((task) => task.title).toString()}');
  }

  //   @override
  //   Widget build(BuildContext context) {
  //     return Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       spacing: 15,
  //       children: <Widget>[
  //         Text(
  //           status,
  //           style: TextStyle(
  //             color: color,
  //             fontSize: 20,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         Container(
  //           width: MediaQuery.of(context).size.width / 3.5,
  //           height: MediaQuery.of(context).size.height / 1.25,
  //           padding: EdgeInsets.all(15),
  //           decoration: const BoxDecoration(
  //             gradient: Gradients.SURFACE,
  //             borderRadius: BorderRadius.all(Radius.elliptical(40, 30)),
  //           ),
  //           child: Column(spacing: 10, children: tasks),
  //         ),
  //       ],
  //     );
  //   }
  // }
}
