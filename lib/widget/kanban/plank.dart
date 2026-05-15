import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/basics.dart';
import 'package:sortack/widget/dialogs.dart';
import 'package:sortack/widget/kanban/block.dart';

/// Kanban column class - task plank view with Kanban card children
final class KanbanColumn {
  final String deckId;
  final Plank tasks;
  final int order;
  final Map<String, UserProfile>? members;
  final VoidCallback onChanged;
  final VoidCallback? onUnfocus;
  final VoidCallback onDelete;

  List<Block> get visibleTasks => tasks.visibleBlocks;
  final TextEditingController _titleController;
  final FocusNode _titleFocus = FocusNode();

  KanbanColumn({
    required this.deckId,
    required this.tasks,
    required this.order,
    this.members,
    required this.onChanged,
    this.onUnfocus,
    required this.onDelete,
  }) : _titleController = TextEditingController(text: tasks.title) {
    _titleFocus.addListener(() async {
      if (!_titleFocus.hasFocus && _titleController.text != tasks.title) {
        tasks.title = _titleController.text;
      }
      onUnfocus?.call();
    });
  }

  void dispose() {
    _titleFocus.dispose();
    _titleController.dispose();
  }

  Widget _buildTitle(BuildContext context) => SizedBox(
    width: MediaQuery.of(context).size.width / 3.3 - 78.0,
    child: TextField(
      controller: _titleController,
      focusNode: _titleFocus,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: tasks.color,
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(15.0),
        filled: true,
        fillColor: Colours.a,
        hoverColor: Colours.CANVAS_AC,
      ),
      onEditingComplete: () {
        _titleFocus.unfocus();
      },
      onTapOutside: (event) {
        _titleFocus.unfocus();
      },
    ),
  );
  Widget _buildColour(BuildContext context) => IconButton(
    icon: const Icon(Icons.colorize_rounded, size: 16, color: Colours.INK),
    onPressed: () async {
      final selected = await showDialog<Color>(
        context: context,
        builder: (context) => ColourGradialog(),
      );
      if (selected != null) {
        tasks.color = selected;
        onUnfocus?.call();
        onChanged();
      }
    },
  );

  DragAndDropList build() {
    return DragAndDropList(
      verticalAlignment: CrossAxisAlignment.center,
      contentsWhenEmpty: Padding(
        padding: const EdgeInsets.only(top: 12.5),
        child: buildEasterEgg(size: 60),
      ),
      decoration: BoxDecoration(
        gradient: Gradients.PLANK,
        borderRadius: BorderRadius.circular(15.0),
      ),
      header: ListenableBuilder(
        listenable: _titleController,
        builder: (context, child) => Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const SizedBox(
              width: 38.0,
              child: Center(
                child: Icon(
                  Icons.drag_indicator_outlined,
                  size: 17,
                  color: Colours.INK_UN,
                ),
              ),
            ),
            _buildTitle(context),
            _buildColour(context),
          ],
        ),
      ),
      children: List.generate(
        visibleTasks.length,
        (index) => DragAndDropItem(
          child: KanbanCard(
            deckId: deckId,
            plankId: tasks.id,
            task: visibleTasks[index],
            order: index,
            members: members,
            onDelete: () {
              tasks.pop(visibleTasks[index]);
              onChanged();
            },
          ),
        ),
      ),
      footer: IconButton(
        onPressed: () => onDelete(),
        icon: const Icon(Icons.remove_rounded, size: 15, color: Colours.GLOSS),
      ),
    );
  }
}
