import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task/task_planks.dart';
export 'package:sortack/logic/task/task_planks.dart';

sealed class TaskDeck<T extends TaskPlank> {
  //extends Collector<T> {
  //final List<T> planks;
  //final Map<String, T> planks;

  //TaskDeck({List<T>? planks}) : planks = planks ?? [];
  //TaskDeck({Map<String, T>? planks}) : planks = planks ?? {};

  //List<T> get visiblePlanks => filter();
  //@override
  //List<T> get collection => planks;

  //List<T> filter();
}
