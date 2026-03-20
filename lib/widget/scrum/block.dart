import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';

/// Scrum row class - advanced task block view for scrum methodology
final class ScrumRow {
  final String deckId, plankId;
  final AdvancedTaskBlock task;
  final int order;
  final Function(AdvancedTaskBlock) onDelete;

  ScrumRow({
    required this.deckId,
    required this.plankId,
    required this.task,
    required this.order,
    required this.onDelete,
  });

  DataRow build() {
    return DataRow(
      cells: [
        DataCell(Text(task.title)),
        DataCell(Text(task.description)),
        DataCell(Text(task.status.label)),
        DataCell(Text(task.priority != null ? task.priority!.label : '-')),
        DataCell(Text(task.points != null ? task.points!.label : '-')),
        DataCell(Text(task.role != null ? task.role! : '-')),
        DataCell(Text(task.deadline != null ? task.deadline!.toString() : '-')),
        DataCell(Text(task.assignee != null ? task.assignee! : '-')),
        DataCell(Text(task.notes)),
      ],
    );
  }
}
    // ListenableBuilder(
    //   listenable: _taskController,
    //   builder: (context, child) => ExpansionTile(
    //     maintainState: true,
    //     expandedCrossAxisAlignment: CrossAxisAlignment.center,
    //     collapsedShape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(34),
    //       side: BorderSide.none,
    //     ),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(34),
    //       side: BorderSide.none,
    //     ),
    //     leading: const Icon(Icons.task_rounded),
    //     title: _buildTitleField(),
    //     subtitle: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         IconButton(
    //           onPressed: () => showDialog(
    //             context: context,
    //             builder: (context) => AcceptDialog(
    //               message: 'Do you realy want to delete this task?...',
    //               onCancel: Navigator.of(context).pop,
    //               onAccept: () async {
    //                 Navigator.of(context).pop();
    //                 widget.onDelete(task);
    //                 await FireRources.deleteBlock(widget.deckId, task.id);
    //               },
    //               icon: Icons.remove_rounded,
    //             ),
    //           ),
    //           icon: Icon(Icons.remove_rounded),
    //         ),
    //       ],
    //     ),
    //     trailing: _buildPointsField(),
    //     children: [_buildDescriptionField(), _buildNotesField()],
    //   ),
    // );
