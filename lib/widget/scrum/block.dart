import 'package:data_table_2/data_table_2.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';

/// Scrum row class - advanced task block view for scrum methodology
final class ScrumRow {
  final String deckId, plankId;
  final int order;
  final VoidCallback onChanged;
  final Function(AdvancedBlock) onDelete;
  late final AdvancedBlockController _taskController;
  AdvancedBlock get task => _taskController.task;

  ScrumRow({
    required this.deckId,
    required this.plankId,
    required AdvancedBlock task,
    required this.order,
    required this.onChanged,
    required this.onDelete,
  }) : _taskController = AdvancedBlockController(
         task,
         onUnfocus: () async {
           try {
             await FireRources.saveBlock(deckId, plankId, task, order);
             debugPrint('+ saving task changes');
             onChanged();
           } catch (exc) {
             debugPrint('? ERROR: saving task changes');
           }
         },
       );

  void dispose() {
    _taskController.dispose();
  }

  DataRow2 build() {
    return DataRow2(
      cells: [
        DataCell(
          TextField(
            controller: _taskController.titleController,
            focusNode: _taskController.titleFocus,
            onEditingComplete: () => _taskController.titleFocus.unfocus(),
            onTapOutside: (event) => _taskController.titleFocus.unfocus(),
            style: Styles.TASK_TITLE_TEXT,
            decoration: Decorations.cardInput(
              collapsed: true,
              hintText: 'I have to do ...',
            ),
          ),
        ),
        DataCell(
          TextFormField(
            controller: _taskController.descriptionController,
            focusNode: _taskController.descriptionFocus,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 4,
            onTapOutside: (event) => _taskController.descriptionFocus.unfocus(),
            style: Styles.TASK_DESCRIPTION_TEXT,
            decoration: Decorations.cardInput(
              collapsed: false,
              labelText: 'Description',
            ),
          ),
        ),
        DataCell(Text(task.deadline != null ? task.deadline!.ddMMMyyyy : '-')),
        DataCell(
          Center(
            child: PopupMenuButton<TaskStatus>(
              tooltip: 'status',
              initialValue: task.status,
              child: Text(task.status.label),
              itemBuilder: (context) => TaskStatus.values
                  .map(
                    (value) =>
                        PopupMenuItem(value: value, child: Text(value.label)),
                  )
                  .toList(),
              onSelected: (value) {
                _taskController.updateStatus(value);
                onChanged();
              },
            ),
          ),
        ),
        DataCell(
          Center(
            child: PopupMenuButton<TaskPriority>(
              tooltip: 'priority',
              initialValue: task.priority,
              child: Text(task.priority != null ? task.priority!.label : '?'),
              itemBuilder: (context) => TaskPriority.values
                  .map(
                    (value) =>
                        PopupMenuItem(value: value, child: Text(value.label)),
                  )
                  .toList(),
              onSelected: (value) {
                _taskController.updatePriority(value);
                onChanged();
              },
            ),
          ),
        ),
        DataCell(
          Center(
            child: PopupMenuButton<TaskPointsTShirt>(
              tooltip: 'points',
              initialValue: task.points,
              child: Text(task.points != null ? task.points!.label : '?'),
              itemBuilder: (context) => TaskPointsTShirt.values
                  .map(
                    (value) =>
                        PopupMenuItem(value: value, child: Text(value.label)),
                  )
                  .toList(),
              onSelected: (value) {
                _taskController.updatePoints(value);
                onChanged();
              },
            ),
          ),
        ),
        DataCell(Center(child: Text(task.role != null ? task.role! : '-'))),
        DataCell(
          Center(child: Text(task.assignee != null ? task.assignee! : '-')),
        ),
        DataCell(
          TextFormField(
            controller: _taskController.notesController,
            focusNode: _taskController.notesFocus,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 2,
            onTapOutside: (event) => _taskController.notesFocus.unfocus(),
            style: Styles.TASK_NOTES_TEXT,
            decoration: Decorations.cardInput(
              collapsed: false,
              labelText: 'Notes',
            ),
          ),
        ),
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
