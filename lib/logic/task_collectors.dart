import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task.dart';
export 'package:sortack/logic/task.dart';

/// abstract task collector class - collection of tasks
sealed class TaskCollector extends Collector<Task>
    with Sortable<Task, TaskParameters>, Filterable<Task, TaskParameters> {
  final List<Task> tasks;

  TaskCollector(List<Task>? tasks) : tasks = tasks ?? [];

  List<Task> get tasksFinal => filter();
  @override
  List<Task> get collection => tasks;

  @override
  void sort({by = TaskParameters.id}) {
    tasks.sort((a, b) => a.compareTo(b, by));
  }
}

/// statused task collector - collection of tasks of a particular status
class StatusedTaskCollector extends TaskCollector {
  String status;
  Color color;

  StatusedTaskCollector(
    super.tasks, {
    this.status = '',
    this.color = Colours.BOTTOM,
  });
}
