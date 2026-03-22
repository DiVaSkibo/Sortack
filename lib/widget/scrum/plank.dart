import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/scrum/block.dart';

/// Scrum table class - titled task plank view with Scrum row children
class ScrumTable extends StatefulWidget {
  final String deckId;
  final Plank<AdvancedBlock> tasks;
  final int order;
  final VoidCallback onChanged;
  final Function()? onUnfocus;
  final Function(Plank<AdvancedBlock>) onDelete;

  List<AdvancedBlock> get visibleTasks => tasks.visibleBlocks;

  ScrumTable({
    Key? key,
    required this.deckId,
    required this.tasks,
    required this.order,
    required this.onChanged,
    this.onUnfocus,
    required this.onDelete,
  }) : super(key: key ?? ObjectKey(tasks));

  @override
  State<ScrumTable> createState() => _ScrumTableState();
}

class _ScrumTableState extends State<ScrumTable> {
  late final Plank<AdvancedBlock> tasks = widget.tasks;
  late final int order = widget.order;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showBottomBorder: true,
      columns: TaskParameters.values
          .skip(1)
          .map((value) => DataColumn(label: Text(value.name)))
          .toList(),
      rows: List.generate(
        tasks.length,
        (index) => ScrumRow(
          deckId: widget.deckId,
          plankId: tasks.id,
          task: tasks[index],
          order: order,
          onDelete: (what) {
            tasks.pop(what);
          },
        ).build(),
      ),
    );
  }
}
    // DragAndDropList(
    //   verticalAlignment: CrossAxisAlignment.center,
    //   decoration: Decorations.PLANK_BOX,
    //   contentsWhenEmpty: Icon(unicon(), size: 30),
    //   header: ListenableBuilder(
    //     listenable: _titleController,
    //     builder: (context, child) => TextField(
    //       controller: _titleController,
    //       focusNode: _titleFocus,
    //       textAlign: TextAlign.center,
    //       onEditingComplete: () {
    //         _titleFocus.unfocus();
    //       },
    //       onTapOutside: (event) {
    //         _titleFocus.unfocus();
    //       },
    //       style: Styles.columnText(color: tasks.color),
    //       decoration: Decorations.columnInput(),
    //     ),
    //   ),
    //   footer: IconButton(
    //     onPressed: () => onDelete(tasks),
    //     icon: Icon(Icons.remove_rounded),
    //   ),
    //   children: List.generate(
    //     visibleTasks.length,
    //     (index) => DragAndDropItem(
    //       feedbackWidget: CircleAvatar(
    //         radius: 12.5,
    //         backgroundColor: Colours.ACTOP,
    //       ),
    //       child: ScrumCard(
    //         deckId: deckId,
    //         plankId: tasks.id,
    //         task: visibleTasks[index],
    //         order: index,
    //         onDelete: (what) {
    //           tasks.pop(what);
    //           onChanged();
    //         },
    //       ),
    //     ),
    //   ),
    // );
