import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task/task_planks.dart';
export 'package:sortack/logic/task/task_planks.dart';

/// sealed task deck class - collection of task planks
sealed class TaskDeck<T extends TaskPlank> extends Collector<T>
    with Sortable<T, TaskParameters>, Filterable<T, TaskParameters> {
  final List<T> planks;
  //final Map<String, T> planks;

  TaskDeck({List<T>? planks, super.listenable}) : planks = planks ?? [];
  //TaskDeck({Map<String, T>? planks}) : planks = planks ?? {};

  @override
  List<T> get collection => planks;

  void pushBlock(TaskBlock block) => planks.first.push(block);

  @override
  void sort({TaskParameters by = TaskParameters.id}) {
    for (final plank in planks) {
      plank.sort(by: by);
    }
  }

  @override
  void updateFilterCriterion({required TaskParameters parameter, criterion}) {
    super.updateFilterCriterion(parameter: parameter, criterion: criterion);
    for (final plank in planks) {
      plank.updateFilterCriterion(parameter: parameter, criterion: criterion);
    }
  }
}

class TaskBoard extends TaskDeck<TitledTaskPlank> {
  String name;

  TaskBoard({required this.name, super.planks, super.listenable});
}
