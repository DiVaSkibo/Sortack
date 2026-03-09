import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/kanban/block.dart';

/// Kanban column class - titled task plank view with Kanban card children
final class KanbanColumn {
  final String deckId;
  final TitledTaskPlank tasks;
  final int order;
  final VoidCallback onChanged;

  List<TaskBlock> get visibleTasks => tasks.visibleBlocks;
  final TextEditingController _titleController;
  final FocusNode _titleFocus = FocusNode();

  KanbanColumn({
    required this.deckId,
    required this.tasks,
    required this.order,
    required this.onChanged,
  }) : _titleController = TextEditingController(text: tasks.title) {
    _titleFocus.addListener(() {
      if (!_titleFocus.hasFocus && _titleController.text != tasks.title) {
        tasks.title = _titleController.text;
      }
    });
  }

  void dispose() {
    _titleController.dispose();
    _titleFocus.dispose();
  }

  DragAndDropList build() {
    return DragAndDropList(
      verticalAlignment: CrossAxisAlignment.center,
      decoration: Decorations.PLANK_BOX,
      header: ListenableBuilder(
        listenable: _titleController,
        builder: (context, child) => TextField(
          controller: _titleController,
          focusNode: _titleFocus,
          textAlign: TextAlign.center,
          onEditingComplete: () {
            _titleFocus.unfocus();
          },
          onTapOutside: (event) {
            _titleFocus.unfocus();
          },
          style: Styles.columnText(color: tasks.color),
          decoration: Decorations.columnInput(),
        ),
      ),
      contentsWhenEmpty: Icon(unicon(), size: 30),
      children: List.generate(
        visibleTasks.length,
        (index) => DragAndDropItem(
          child: KanbanCard(
            deckId: deckId,
            plankId: tasks.id,
            task: visibleTasks[index],
            order: index,
            onDelete: (what) {
              tasks.pop(what);
              onChanged();
            },
          ),
        ),
      ),
    );
  }
}
