import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/scrum/plank.dart';

/// Scrum board widget - task board view with Scrum table children
class ScrumBoard extends StatefulWidget {
  final String id;
  final AdvancedDeck tables;
  final AdvancedDeck nextTables;
  final Map<String, UserProfile>? members;
  final ScrumArtefact artefact;

  const ScrumBoard({
    super.key,
    required this.id,
    required this.tables,
    required this.nextTables,
    this.members,
    required this.artefact,
  });

  @override
  State<ScrumBoard> createState() => _ScrumBoardState();
}

class _ScrumBoardState extends State<ScrumBoard> {
  late final String id = widget.id;
  late final AdvancedDeck board = widget.tables;
  late final AdvancedDeck nextBoard = widget.nextTables;
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
        verticalDirection: VerticalDirection.up,
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
              ictions: switch (widget.artefact) {
                ScrumArtefact.sprintBacklog => [
                  Iction(
                    icon: Icons.flag_outlined,
                    callback: () async {
                      // pop
                      final AdvancedPlank sprint = board.popAt(index);
                      // modify information for the next artefact
                      if (sprint.title.isEmpty) {
                        sprint.title = 'Increment ${DateTime.now().ddMMMyyyy}';
                      } else {
                        sprint.title = sprint.title.replaceAll(
                          'Sprint',
                          'Increment',
                        );
                        sprint.title = sprint.title.replaceAll(
                          'sprint',
                          'increment',
                        );
                      }
                      sprint.color = ScrumArtefact.increments.colour;
                      // push
                      nextBoard.push(sprint, front: true);
                      // fire
                      await FireRources.savePlank(
                        id,
                        sprint,
                        nextBoard.length,
                        key: ScrumArtefact.increments.label,
                      );
                    },
                  ),
                ],
                _ => null,
              },
              constant: widget.artefact != ScrumArtefact.increments,
              onDelete: widget.artefact != ScrumArtefact.productBacklog
                  ? () {
                      setState(() {
                        board.popAt(index);
                      });
                    }
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
