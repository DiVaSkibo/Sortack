import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/kanban/plank.dart';

/// Kanban board widget - task board view with Kanban column children
class KanbanBoard extends StatefulWidget {
  final DetailedTaskDeck columns;

  const KanbanBoard({super.key, required this.columns});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
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
              (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
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
              },
          onListReorder: (oldListIndex, newListIndex) {
            setState(() {
              board.move(oldListIndex, newListIndex);
            });
          },
        ),
      ),
    );
  }
}
