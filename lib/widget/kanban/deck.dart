import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/kanban/plank.dart';
import 'package:sortack/widget/dialogs.dart';

/// Kanban board widget - task board view with Kanban column children
class KanbanBoard extends StatefulWidget {
  final String id;
  final Deck columns;
  final Map<String, UserProfile>? members;

  const KanbanBoard({
    super.key,
    required this.id,
    required this.columns,
    this.members,
  });

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  late final String id = widget.id;
  late final Deck board = widget.columns;
  final ScrollController _columnsScrollController = ScrollController();

  @override
  void dispose() {
    _columnsScrollController.dispose();
    super.dispose();
  }

  void updateTaskList(int index) async {
    // fire
    try {
      await FireRources.savePlank(id, board[index], index);
    } catch (exc) {
      debugPrint('? ERROR: saving column changes; $exc');
    }
  }

  void deleteTaskList(Plank taskList) async {
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
    return Scrollbar(
      controller: _columnsScrollController,
      scrollbarOrientation: ScrollbarOrientation.top,
      child: ListenableBuilder(
        listenable: board,
        builder: (context, child) => DragAndDropLists(
          scrollController: _columnsScrollController,
          axis: Axis.horizontal,
          horizontalAlignment: MainAxisAlignment.center,
          verticalAlignment: CrossAxisAlignment.center,
          lastItemTargetHeight: 200,
          itemDragOnLongPress: false,
          listDragOnLongPress: false,
          itemDragHandle: DragHandle(
            onLeft: true,
            verticalAlignment: DragHandleVerticalAlignment.top,
            child: Container(
              width: 44,
              height: 58,
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusGeometry.only(
                  topLeft: Radius.circular(34.0),
                ),
              ),
            ),
          ),
          itemGhostOpacity: 0.6,
          itemGhost: const DottedBorder(
            options: RoundedRectDottedBorderOptions(
              strokeCap: StrokeCap.round,
              radius: Radius.circular(36.0),
              strokeWidth: 2,
              dashPattern: <double>[18.0, 8.0],
              color: Colours.CENTER,
            ),
            child: CircleAvatar(backgroundColor: Colours.o),
          ),
          listPadding: const EdgeInsets.all(8.0),
          listWidth: MediaQuery.of(context).size.width / 3.3,
          listDragHandle: DragHandle(
            onLeft: true,
            verticalAlignment: DragHandleVerticalAlignment.top,
            child: Container(
              width: 44,
              height: 52,
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusGeometry.only(
                  topLeft: Radius.circular(16.0),
                ),
              ),
            ),
          ),
          listGhostOpacity: 0.6,
          listGhost: const DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(47.5),
              strokeWidth: 2,
              dashPattern: <double>[36.0, 16.0],
              color: Colours.BOTTOM,
            ),
            child: CircleAvatar(radius: 47.5, backgroundColor: Colours.o),
          ),
          children: List.generate(
            board.length,
            (index) => KanbanColumn(
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
                  message: 'Do you realy want to delete this column?...',
                  onAccept: () => deleteTaskList(plank),
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
