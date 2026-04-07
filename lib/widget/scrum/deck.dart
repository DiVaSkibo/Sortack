import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/scrum/plank.dart';
import 'package:sortack/widget/dialogs.dart';

/// Scrum board widget - task board view with Scrum table children
class ScrumBoard extends StatefulWidget {
  final String id;
  final AdvancedDeck tables;

  const ScrumBoard({super.key, required this.id, required this.tables});

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
                onChanged: () {
                  setState(() {});
                },
                onUnfocus: () async {
                  try {
                    await FireRources.savePlank(id, board[index], index);
                  } catch (exc) {
                    debugPrint('? ERROR: saving column changes; $exc');
                  }
                },
                onDelete: (plank) => showDialog(
                  context: context,
                  builder: (context) => AcceptDialog(
                    message: 'Do you realy want to delete this task?...',
                    onCancel: Navigator.of(context).pop,
                    onAccept: () async {
                      Navigator.of(context).pop();
                      setState(() {
                        board.pop(plank);
                      });
                      await FireRources.deletePlank(id, plank.id);
                    },
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
