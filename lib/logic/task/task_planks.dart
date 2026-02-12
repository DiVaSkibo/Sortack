import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task/task_blocks.dart';
export 'package:sortack/logic/task/task_blocks.dart';

/// abstract task plank class - collection of task blocks
sealed class TaskPlank extends Collector<TaskBlock>
    with
        Sortable<TaskBlock, TaskParameters>,
        Filterable<TaskBlock, TaskParameters> {
  final List<TaskBlock> blocks;

  TaskPlank({List<TaskBlock>? blocks}) : blocks = blocks ?? [];

  List<TaskBlock> get visibleblocks => filter();
  @override
  List<TaskBlock> get collection => blocks;

  @override
  void sort({by = TaskParameters.id}) {
    blocks.sort((a, b) => a.compareTo(b, by));
  }
}

/// titled task plank - collection of task blocks of a particular title
class TitledTaskPlank extends TaskPlank {
  String title;
  Color color;

  TitledTaskPlank({super.blocks, this.title = '', this.color = Colours.BOTTOM});
}
