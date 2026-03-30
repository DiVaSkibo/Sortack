import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/scrum/plank.dart';
import 'package:sortack/widget/dialogs.dart';

/// Scrum board widget - task board view with Scrum table children
class ScrumBoard extends StatefulWidget {
  final String id;
  final AdvancedDeck tables;
  final int selectedIndex;

  const ScrumBoard({
    super.key,
    required this.id,
    required this.tables,
    this.selectedIndex = 0,
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1000,
      child: ListenableBuilder(
        listenable: board,
        builder: (context, child) => ScrumTable(
          deckId: id,
          tasks: board[widget.selectedIndex],
          order: widget.selectedIndex,
          onChanged: () {
            setState(() {});
          },
          onUnfocus: () async {
            try {
              await FireRources.savePlank(
                id,
                board[widget.selectedIndex],
                widget.selectedIndex,
              );
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
    );
  }
}
