import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/kanban/plank.dart';

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
          // itemDragOnLongPress: false,
          // listDragOnLongPress: false,
          scrollController: _columnsScrollController,
          children: board.planks
              .map(
                (plank) => KanbanColumn(
                  tasks: plank,
                  onChanged: () {
                    setState(() {});
                  },
                ).build(),
              )
              .toList(),
          onItemReorder:
              (oldItemIndex, oldListIndex, newItemIndex, newListIndex) async {
                if (oldListIndex == newListIndex) {
                  setState(() {
                    board[newListIndex].move(oldItemIndex, newItemIndex);
                  });
                } else {
                  var task = board[oldListIndex].blocks[oldItemIndex];
                  setState(() {
                    board[oldListIndex].pop(task);
                    board[newListIndex].insert(task, newItemIndex);
                  });
                }
                FireRources.getBlocks(
                  id,
                ).doc().update({'plankId': board[newListIndex].id});
              },
          onListReorder: (oldListIndex, newListIndex) async {
            setState(() {
              board.move(oldListIndex, newListIndex);
            });
            final batch = FirebaseFirestore.instance.batch();
            for (int i = 0; i < board.planks.length; i++) {
              final plankId = board.planks[i].id;
              final plankRef = FireRources.getPlanks(id).doc(plankId);
              batch.update(plankRef, {'order': i});
            }
            await batch.commit();
          },
        ),
      ),
    );
  }
}
