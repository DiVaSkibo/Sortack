import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task/blocks.dart';
import 'package:sortack/logic/task/planks.dart';

/// advanced deck - collection of advanced planks
typedef AdvancedDeck = Deck<AdvancedPlank>;

/// advanced map deck - key-value collections of advanced planks
typedef AdvancedMapDeck = MapDeck<AdvancedPlank>;

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

/// map task deck interface class - key-value collections of task planks
interface class MapDeck<T extends Plank> extends Deck<T> {
  final Map<String, Deck<T>> decks;
  String? selectedKey;

  MapDeck({this.selectedKey, Map<String, Deck<T>>? decks, super.listenable})
    : decks = decks ?? {};

  Iterable<String> get keys => decks.keys;
  Iterable<Deck<T>> get values => decks.values;

  @override
  List<T> get planks => (decks[selectedKey] as Deck<T>).planks;
  Deck<T> get deck => decks[selectedKey] as Deck<T>;
  Deck<T> deckOf(String key) => decks[key] as Deck<T>;
}
