import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task/blocks.dart';

/// advanced task plank - collection of advanced task blocks
typedef AdvancedTaskPlank = TaskPlank<AdvancedTaskBlock>;

/// task plank interface class - collection of task blocks
interface class TaskPlank<T extends TaskBlock> extends Collector<T>
    with Sortable<T, TaskParameters>, Filterable<T, TaskParameters> {
  final String id;
  final List<T> blocks;
  String title;
  Color color;

  TaskPlank({
    required this.id,
    this.title = '',
    this.color = Colours.BOTTOM,
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
// interface class TitledTaskPlank extends TaskPlank {
//   String title;
//   Color color;

//   TitledTaskPlank({
//     required super.id,
//     this.title = '',
//     this.color = Colours.BOTTOM,
//     super.blocks,
//     super.listenable,
//   });
// }
