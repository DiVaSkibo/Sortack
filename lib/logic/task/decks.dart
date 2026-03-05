import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task/blocks.dart';
import 'package:sortack/logic/task/planks.dart';

/// sealed task deck class - collection of task planks
sealed class TaskDeck<T extends TaskPlank> extends Collector<T>
    with Sortable<T, TaskParameters>, Filterable<T, TaskParameters> {
  final List<T> planks;

  TaskDeck({List<T>? planks, super.listenable}) : planks = planks ?? [];

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
  void filter(FilterCriteria<TaskParameters> criteria) {
    super.filter(criteria);
    for (final plank in planks) {
      plank.filter(criteria);
    }
  }
}

/// final deck details class
final class DeckDetails {
  String name;
  String? description;
  Methodology methodology;
  DateTime created;
  String owner;
  List<String> members;

  DeckDetails({
    required this.name,
    required this.methodology,
    this.description = '',
    required this.created,
    required this.owner,
    List<String>? members,
  }) : members = members ?? [];
}

/// detailed task deck - task deck with details
class DetailedTaskDeck extends TaskDeck<TitledTaskPlank> {
  final DeckDetails? details;

  DetailedTaskDeck({super.planks, super.listenable, required this.details})
    : super();
}
