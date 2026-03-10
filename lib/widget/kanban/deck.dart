import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/kanban/plank.dart';
import 'package:sortack/widget/dialogs.dart';

/// Kanban board widget - task board view with Kanban column children
class KanbanBoard extends StatefulWidget {
  final String id;
  final DetailedTaskDeck columns;

  const KanbanBoard({super.key, required this.id, required this.columns});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  late final String id = widget.id;
  late final DetailedTaskDeck board = widget.columns;
  final ScrollController _columnsScrollController = ScrollController();

  @override
  void dispose() {
    _columnsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _columnsScrollController,
      scrollbarOrientation: ScrollbarOrientation.top,
      child: ListenableBuilder(
        listenable: board,
        builder: (context, child) => DragAndDropLists(
          axis: Axis.horizontal,
          listWidth: MediaQuery.of(context).size.width / 3,
          listPadding: const EdgeInsets.all(8.0),
          lastItemTargetHeight: 200,
          itemDragOnLongPress: false,
          listDragOnLongPress: false,
          scrollController: _columnsScrollController,
          children: List.generate(
            board.length,
            (index) => KanbanColumn(
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
            ).build(),
          ),
          onItemReorder:
              (oldItemIndex, oldListIndex, newItemIndex, newListIndex) async {
                if (oldListIndex == newListIndex) {
                  setState(() {
                    board[newListIndex].move(oldItemIndex, newItemIndex);
                  });
                  FireRources.updateBlocksOrder(id, board[newListIndex]);
                } else {
                  var task = board[oldListIndex].blocks[oldItemIndex];
                  setState(() {
                    board[oldListIndex].pop(task);
                    board[newListIndex].insert(task, newItemIndex);
                  });
                  FireRources.updateBlocksOrder(id, board[oldListIndex]);
                  FireRources.updateBlocksOrder(id, board[newListIndex]);
                }
              },
          onListReorder: (oldListIndex, newListIndex) async {
            setState(() {
              board.move(oldListIndex, newListIndex);
            });
            FireRources.updatePlanksOrder(id, board);
          },
        ),
      ),
    );
  }
}
