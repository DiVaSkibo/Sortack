import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task/blocks.dart';

/// advanced task plank - collection of advanced task blocks
typedef AdvancedPlank = Plank<AdvancedBlock>;

/// task plank interface class - collection of task blocks
interface class Plank<T extends Block> extends Collector<T>
    with Sortable<T, TaskParameters>, Filterable<T, TaskParameters> {
  final String id;
  final List<T> blocks;
  String title;
  Color color;

  Plank({
    required this.id,
    this.title = '',
    this.color = Colours.ANCHOR,
    List<T>? blocks,
    super.listenable,
  }) : blocks = blocks ?? [];

  List<T> get visibleBlocks => filtered;
  @override
  List<T> get collection => blocks;

  @override
  void sort({by = TaskParameters.id}) {
    blocks.sort((a, b) => a.compareTo(b, by));
  }
}

// /// task plank interface class
// interface class TitledPlank extends Plank {
//   String title;
//   Color color;

//   TitledPlank({
//     required super.id,
//     this.title = '',
//     this.color = Colours.ANCHOR,
//     super.blocks,
//     super.listenable,
//   });
// }
