import 'package:sortack/_tools.dart';
import 'package:sortack/logic/task/task_planks.dart';
export 'package:sortack/logic/task/task_planks.dart';

/// sealed task deck class - collection of task planks
sealed class TaskDeck<T extends TaskPlank> extends Collector<T> {
  final List<T> planks;
  //final Map<String, T> planks;

  TaskDeck({List<T>? planks}) : planks = planks ?? [];
  //TaskDeck({Map<String, T>? planks}) : planks = planks ?? {};

  @override
  List<T> get collection => planks;
}

class TaskBoard extends TaskDeck<TitledTaskPlank> {
  String name;

  TaskBoard({super.planks, required this.name});
}
