import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task.dart';
export 'package:sortack/logic/task.dart';

/// abstract task collector class - collection of tasks
sealed class TaskCollector extends Collector<Task>
    with Sortable<Task, TaskParameters>, Filterable<Task, TaskParameters> {
  final List<Task> tasks;

  TaskCollector({List<Task>? tasks}) : tasks = tasks ?? [];

  List<Task> get visibleTasks => filter();
  @override
  List<Task> get collection => tasks;

  @override
  void sort({by = TaskParameters.id}) {
    tasks.sort((a, b) => a.compareTo(b, by));
  }
}

/// titled task collector - collection of tasks of a particular title
class TitledTaskCollector extends TaskCollector {
  String title;
  Color color;

  TitledTaskCollector({
    super.tasks,
    this.title = '',
    this.color = Colours.BOTTOM,
  });
}
