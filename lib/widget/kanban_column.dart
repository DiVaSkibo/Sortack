import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/tool/_consts.dart';
import 'package:sortack/tool/_oop.dart';
import 'package:sortack/widget/kanban_card.dart';

class KanbanColumn {
  String status;
  final List<Task> tasks;
  Color? color;

  KanbanColumn({required this.status, required this.tasks, this.color});

  final _filter = {};

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
            onDelete: (what) => pop(what),
          ),
        ),
      ),
    );
  }
}
