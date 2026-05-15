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

  void _sprintToIncrement(int index) async {
    // pop
    final AdvancedPlank sprint = board.popAt(index);
    // modify information for the next artefact
    if (sprint.title.isEmpty) {
      sprint.title = 'Increment ${DateTime.now().ddMMMyyyy}';
    } else {
      sprint.title = sprint.title.replaceAll('Sprint', 'Increment');
      sprint.title = sprint.title.replaceAll('sprint', 'increment');
    }
    sprint.color = ScrumArtefact.increments.colour;
    for (var task in sprint.blocks) task.enabled = false;
    // push
    nextBoard.push(sprint, 0);
    // fire
    await FireRources.savePlank(
      id,
      sprint,
      nextBoard.length,
      key: ScrumArtefact.increments.label,
    );
  }

  void _incrementToSprint(int index) async {
    // pop
    final AdvancedPlank increment = board.popAt(index);
    // modify information for the next artefact
    if (increment.title.isEmpty) {
      increment.title = 'Sprint ${DateTime.now().ddMMMyyyy}';
    } else {
      increment.title = increment.title.replaceAll('Increment', 'Sprint');
      increment.title = increment.title.replaceAll('increment', 'sprint');
    }
    increment.color = ScrumArtefact.sprintBacklog.colour;
    for (var task in increment.blocks) task.enabled = true;
    // push
    nextBoard.push(increment, 0);
    // fire
    await FireRources.savePlank(
      id,
      increment,
      nextBoard.length,
      key: ScrumArtefact.sprintBacklog.label,
    );
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
                    icon: Icons.outlined_flag_rounded,
                    callback: () => _sprintToIncrement(index),
                  ),
                ],
                ScrumArtefact.increments => [
                  Iction(
                    icon: Icons.emoji_flags_rounded,
                    callback: () => _incrementToSprint(index),
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
