import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task/blocks.dart';
import 'package:sortack/logic/task/planks.dart';

/// advanced task deck - collection of advanced task planks
typedef AdvancedDeck = DetailedDeck<AdvancedPlank>;

/// task deck interface class - collection of task planks
interface class Deck<T extends Plank> extends Collector<T>
    with Sortable<T, TaskParameters>, Filterable<T, TaskParameters> {
  final List<T> planks;

  Deck({List<T>? planks, super.listenable}) : planks = planks ?? [];

  @override
  List<T> get collection => planks;

  void pushBlock(Block block) => planks.first.push(block);

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

/// detailed task deck interface class - collection of task planks with details
interface class DetailedDeck<T extends Plank> extends Deck<T> {
  final DeckDetails? details;

  DetailedDeck({super.planks, super.listenable, required this.details})
    : super();
}

/// final deck details class
final class DeckDetails {
  final String id;
  String name;
  String? description;
  Methodology methodology;
  DateTime created;
  String owner;
  List<String> members;

  DeckDetails({
    required this.id,
    required this.name,
    required this.methodology,
    this.description = '',
    required this.created,
    required this.owner,
    List<String>? members,
  }) : members = members ?? [];
}
