import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/scrum/plank.dart';
import 'package:sortack/widget/dialogs.dart';

/// Scrum board widget - task board view with Scrum table children
class ScrumBoard extends StatefulWidget {
  final String id;
  final AdvancedDeck tables;
  final Map<String, UserProfile>? members;

  const ScrumBoard({
    super.key,
    required this.id,
    required this.tables,
    this.members,
  });

  @override
  State<ScrumBoard> createState() => _ScrumBoardState();
}

class _ScrumBoardState extends State<ScrumBoard> {
  late final String id = widget.id;
  late final AdvancedDeck board = widget.tables;
  final ScrollController _tableScrollController = ScrollController();

  @override
  void dispose() {
    _tableScrollController.dispose();
    super.dispose();
  }

  void updateTaskList(int index) async {
    // fire
    try {
      await FireRources.savePlank(id, board[index], index);
    } catch (exc) {
      debugPrint('? ERROR: saving table changes; $exc');
    }
  }

  void deleteTaskList(AdvancedPlank taskList) async {
    // delete tasks inside
    for (final task in taskList.blocks)
      await FireRources.deleteBlock(id, task.id);
    // display
    setState(() {
      board.pop(taskList);
    });
    // fire
    await FireRources.deletePlank(id, taskList.id);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          board.length,
          (index) => ListenableBuilder(
            listenable: board,
            builder: (context, child) => Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: ScrumTable(
                deckId: id,
                tasks: board[index],
                order: index,
                members: widget.members,
                onChanged: () {
                  setState(() {});
                },
                onUnfocus: () => updateTaskList(index),
                onDelete: (plank) => showDialog(
                  context: context,
                  builder: (context) => AcceptGradialog(
                    message: 'Do you realy want to delete this table?...',
                    onAccept: () => deleteTaskList(plank),
                    icon: Icons.remove_rounded,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
