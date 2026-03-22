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
  final ScrollController _columnsScrollController = ScrollController();

  @override
  void dispose() {
    _columnsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrumTable(
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
    );
    // List.generate(
    //   board.length,
    //   (index) => ScrumTable(
    //     deckId: id,
    //     tasks: board[index],
    //     order: index,
    //     onChanged: () {
    //       setState(() {});
    //     },
    //     onUnfocus: () async {
    //       try {
    //         await FireRources.savePlank(id, board[index], index);
    //       } catch (exc) {
    //         debugPrint('? ERROR: saving column changes; $exc');
    //       }
    //     },
    //     onDelete: (plank) => showDialog(
    //       context: context,
    //       builder: (context) => AcceptDialog(
    //         message: 'Do you realy want to delete this task?...',
    //         onCancel: Navigator.of(context).pop,
    //         onAccept: () async {
    //           Navigator.of(context).pop();
    //           setState(() {
    //             board.pop(plank);
    //           });
    //           await FireRources.deletePlank(id, plank.id);
    //         },
    //         icon: Icons.remove_rounded,
    //       ),
    //     ),
    //   ),
    // ),
    // Scrollbar(
    //   controller: _columnsScrollController,
    //   scrollbarOrientation: ScrollbarOrientation.top,
    //   child: ListenableBuilder(
    //     listenable: board,
    //     builder: (context, child) => DragAndDropLists(
    //       scrollController: _columnsScrollController,
    //       axis: Axis.horizontal,
    //       horizontalAlignment: MainAxisAlignment.center,
    //       verticalAlignment: CrossAxisAlignment.center,
    //       lastItemTargetHeight: 200,
    //       itemDragOnLongPress: false,
    //       listDragOnLongPress: false,
    //       itemDragHandle: DragHandle(
    //         onLeft: true,
    //         verticalAlignment: DragHandleVerticalAlignment.top,
    //         child: Container(
    //           width: 44,
    //           height: 58,
    //           decoration: const BoxDecoration(
    //             borderRadius: BorderRadiusGeometry.only(
    //               topLeft: Radius.circular(34.0),
    //             ),
    //           ),
    //         ),
    //       ),
    //       itemGhostOpacity: 0.6,
    //       itemGhost: const DottedBorder(
    //         options: RoundedRectDottedBorderOptions(
    //           strokeCap: StrokeCap.round,
    //           radius: Radius.circular(36.0),
    //           strokeWidth: 2,
    //           dashPattern: <double>[18.0, 8.0],
    //           color: Colours.CENTER,
    //         ),
    //         child: CircleAvatar(backgroundColor: Colours.o),
    //       ),
    //       listPadding: const EdgeInsets.all(8.0),
    //       listWidth: MediaQuery.of(context).size.width / 3.3,
    //       listDragHandle: DragHandle(
    //         onLeft: true,
    //         verticalAlignment: DragHandleVerticalAlignment.top,
    //         child: Container(
    //           width: 44,
    //           height: 52,
    //           decoration: const BoxDecoration(
    //             borderRadius: BorderRadiusGeometry.only(
    //               topLeft: Radius.circular(16.0),
    //             ),
    //           ),
    //         ),
    //       ),
    //       listGhostOpacity: 0.6,
    //       listGhost: const DottedBorder(
    //         options: RoundedRectDottedBorderOptions(
    //           radius: Radius.circular(47.5),
    //           strokeWidth: 2,
    //           dashPattern: <double>[36.0, 16.0],
    //           color: Colours.BOTTOM,
    //         ),
    //         child: CircleAvatar(radius: 47.5, backgroundColor: Colours.o),
    //       ),
    //       children: List.generate(
    //         board.length,
    //         (index) => ScrumColumn(
    //           deckId: id,
    //           tasks: board[index],
    //           order: index,
    //           onChanged: () {
    //             setState(() {});
    //           },
    //           onUnfocus: () async {
    //             try {
    //               await FireRources.savePlank(id, board[index], index);
    //             } catch (exc) {
    //               debugPrint('? ERROR: saving column changes; $exc');
    //             }
    //           },
    //           onDelete: (plank) => showDialog(
    //             context: context,
    //             builder: (context) => AcceptDialog(
    //               message: 'Do you realy want to delete this task?...',
    //               onCancel: Navigator.of(context).pop,
    //               onAccept: () async {
    //                 Navigator.of(context).pop();
    //                 setState(() {
    //                   board.pop(plank);
    //                 });
    //                 await FireRources.deletePlank(id, plank.id);
    //               },
    //               icon: Icons.remove_rounded,
    //             ),
    //           ),
    //         ).build(),
    //       ),
    //       onItemReorder:
    //           (oldItemIndex, oldListIndex, newItemIndex, newListIndex) async {
    //             if (oldListIndex == newListIndex) {
    //               setState(() {
    //                 board[newListIndex].move(oldItemIndex, newItemIndex);
    //               });
    //               FireRources.updateBlocksOrder(id, board[newListIndex]);
    //             } else {
    //               var task = board[oldListIndex].blocks[oldItemIndex];
    //               setState(() {
    //                 board[oldListIndex].pop(task);
    //                 board[newListIndex].insert(task, newItemIndex);
    //               });
    //               FireRources.updateBlocksOrder(id, board[oldListIndex]);
    //               FireRources.updateBlocksOrder(id, board[newListIndex]);
    //             }
    //           },
    //       onListReorder: (oldListIndex, newListIndex) async {
    //         setState(() {
    //           board.move(oldListIndex, newListIndex);
    //         });
    //         FireRources.updatePlanksOrder(id, board);
    //       },
    //     ),
    //   ),
    // );
  }
}
