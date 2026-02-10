import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task.dart';

/// abstract task collector class - collection of tasks
abstract class TaskCollector extends Collector<Task>
    with Sortable<Task, TaskParameters>, Filterable<Task, TaskParameters> {
  final List<Task> tasks = [];

  TaskCollector();

  List<Task> get tasksFinal => filter();
  @override
  List<Task> get collection => tasks;

  @override
  void sort({by = TaskParameters.id}) {
    tasks.sort((a, b) => a.compareTo(b, by));
  }
}
