import 'package:data_table_2/data_table_2.dart';
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
    return DataTable2(
      horizontalMargin: 0,
      minWidth: 1920,
      fixedLeftColumns: 1,
      showBottomBorder: true,
      headingRowHeight: 40,
      columnSpacing: 0,
      dividerThickness: 0,
      empty: Icon(Icons.not_interested_rounded),
      dataRowColor: WidgetStatePropertyAll(Colours.TINGE),
      headingRowColor: WidgetStatePropertyAll(Colours.UNTOP),
      fixedCornerColor: Colours.ACTOP,
      fixedColumnsColor: Colours.SHADOW,
      border: TableBorder.symmetric(
        inside: BorderSide(width: .1, color: Colours.TOP),
        outside: BorderSide(width: 2, color: Colours.TOP),
      ),
      columns: [
        DataColumn2(
          headingRowAlignment: MainAxisAlignment.center,
          isResizable: true,
          minWidth: 100,
          fixedWidth: 200,
          label: Text('Title'),
        ),
        DataColumn2(
          headingRowAlignment: MainAxisAlignment.center,
          isResizable: true,
          fixedWidth: 225,
          label: Text('Description'),
        ),
        DataColumn2(
          headingRowAlignment: MainAxisAlignment.center,
          fixedWidth: 125,
          label: Text('Deadline'),
        ),
        DataColumn2(
          headingRowAlignment: MainAxisAlignment.center,
          fixedWidth: 125,
          label: Text('Status'),
        ),
        DataColumn2(
          headingRowAlignment: MainAxisAlignment.center,
          fixedWidth: 125,
          label: Text('Priority'),
        ),
        DataColumn2(
          headingRowAlignment: MainAxisAlignment.center,
          fixedWidth: 100,
          label: Text('Points'),
        ),
        DataColumn2(
          headingRowAlignment: MainAxisAlignment.center,
          fixedWidth: 100,
          label: Text('Role'),
        ),
        DataColumn2(
          headingRowAlignment: MainAxisAlignment.center,
          fixedWidth: 100,
          label: Text('Assignee'),
        ),
        DataColumn2(
          headingRowAlignment: MainAxisAlignment.center,
          isResizable: true,
          minWidth: 100,
          fixedWidth: 100,
          label: Text('Notes'),
        ),
      ],
      rows: List.generate(
        tasks.length,
        (index) => ScrumRow(
          context: context,
          deckId: widget.deckId,
          plankId: tasks.id,
          task: tasks[index],
          order: order,
          onChanged: () => setState(() {}),
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
