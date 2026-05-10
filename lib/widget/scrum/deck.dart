import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/scrum/plank.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 15,
        children: List.generate(
          board.length,
          (index) => ListenableBuilder(
            listenable: board,
            builder: (context, child) => ScrumTable(
              deckId: id,
              tasks: board[index],
              order: index,
              members: widget.members,
              onDelete:
                  // IF IS NOT "Product Backlog"
                  (what) {
                    setState(() {
                      board.pop(what);
                    });
                  },
            ),
          ),
        ),
      ),
    );
  }
}
