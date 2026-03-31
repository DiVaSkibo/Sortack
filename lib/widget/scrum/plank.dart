import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/scrum/block.dart';

/// Scrum table class - titled task plank view with Scrum row children
class ScrumTable extends StatefulWidget {
  final String deckId;
  final Plank<AdvancedBlock> tasks;
  final int order;
  final VoidCallback onChanged;
  final Function()? onUnfocus;
  final Function(Plank<AdvancedBlock>) onDelete;

  List<AdvancedBlock> get visibleTasks => tasks.visibleBlocks;

  ScrumTable({
    Key? key,
    required this.deckId,
    required this.tasks,
    required this.order,
    required this.onChanged,
    this.onUnfocus,
    required this.onDelete,
  }) : super(key: key ?? ObjectKey(tasks));

  @override
  State<ScrumTable> createState() => _ScrumTableState();
}

class _ScrumTableState extends State<ScrumTable> {
  late final Plank<AdvancedBlock> tasks = widget.tasks;
  late final int order = widget.order;

  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scrollbar(
        controller: _horizontalController,
        scrollbarOrientation: ScrollbarOrientation.top,
        child: SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: constraints.maxWidth > 1200 ? constraints.maxWidth : 1200,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colours.UNTOP,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Expanded(flex: 3, child: Center(child: Text('Title'))),
                      Expanded(
                        flex: 4,
                        child: Center(child: Text('Description')),
                      ),
                      Expanded(flex: 2, child: Center(child: Text('Deadline'))),
                      Expanded(flex: 2, child: Center(child: Text('Status'))),
                      Expanded(flex: 2, child: Center(child: Text('Priority'))),
                      Expanded(flex: 2, child: Center(child: Text('Points'))),
                      Expanded(flex: 2, child: Center(child: Text('Role'))),
                      Expanded(flex: 2, child: Center(child: Text('Assignee'))),
                      Expanded(flex: 3, child: Center(child: Text('Notes'))),
                    ],
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) => ScrumRow(
                      deckId: widget.deckId,
                      plankId: tasks.id,
                      task: tasks[index],
                      order: order,
                      onDelete: (what) {
                        setState(() {
                          tasks.pop(what);
                        });
                      },
                    ),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex -= 1;
                        tasks.move(oldIndex, newIndex);
                      });
                      FireRources.updateBlocksOrder(widget.deckId, tasks);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
