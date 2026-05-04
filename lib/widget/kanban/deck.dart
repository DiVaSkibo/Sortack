import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/kanban/plank.dart';
import 'package:sortack/widget/dialogs.dart';

/// Kanban board widget - task deck view with Kanban column children
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
      debugPrint('? ERROR: on saving column changes; $exc');
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

  List<DragAndDropList> _buildColumns() => List.generate(
    board.length,
    (index) => KanbanColumn(
      deckId: id,
      tasks: board[index],
      order: index,
      members: widget.members,
      onChanged: () => setState(() {}),
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
  );

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
          // Item
          lastItemTargetHeight: 133.3,
          itemDragOnLongPress: false,
          itemDragHandle: DragHandle(
            onLeft: true,
            verticalAlignment: DragHandleVerticalAlignment.top,
            child: Container(width: 38, height: 58, color: Colours.o),
          ),
          itemGhostOpacity: 1.0,
          itemGhost: const DottedBorder(
            options: RoundedRectDottedBorderOptions(
              borderPadding: EdgeInsets.all(6.0),
              strokeCap: StrokeCap.round,
              strokeWidth: 3,
              radius: Radius.circular(36.0),
              dashPattern: <double>[10.0, 15.0],
              gradient: LinearGradient(
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomLeft,
                colors: [Colours.CENTER, Colours.ACCENTER],
              ),
            ),
            child: SizedBox(width: double.infinity, height: 45.0),
          ),
          // List
          listPadding: const EdgeInsets.all(8.0),
          listWidth: MediaQuery.of(context).size.width / 3.3,
          lastListTargetSize: 15.0,
          listDragOnLongPress: false,
          listDividerOnLastChild: false,
          listDragHandle: DragHandle(
            onLeft: true,
            verticalAlignment: DragHandleVerticalAlignment.top,
            child: Container(
              width: 38.0,
              height: 44.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusGeometry.only(
                  topLeft: Radius.circular(16.0),
                ),
                color: Colours.o,
              ),
            ),
          ),
          listGhostOpacity: 1.0,
          listGhost: const DottedBorder(
            options: RoundedRectDottedBorderOptions(
              borderPadding: EdgeInsets.all(6.0),
              strokeCap: StrokeCap.round,
              strokeWidth: 3,
              radius: Radius.circular(20.0),
              dashPattern: <double>[10.0, 15.0],
              gradient: LinearGradient(
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.centerLeft,
                colors: [Colours.BOTTOM, Colours.ACBOTTOM],
              ),
            ),
            child: SizedBox(width: 111.0, height: 222.0),
          ),
          // Master
          children: _buildColumns(),
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
