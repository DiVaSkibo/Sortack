import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/_widgets.dart';

class KanbanPage extends StatefulWidget {
  final String id;

  const KanbanPage({super.key, required this.id});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  late String id = widget.id;
  late final DetailedDeck? board;
  bool isLoading = true;

  final SwitchDrawersController _switchDrawersController =
      SwitchDrawersController();
  final _buf = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final loadedDeck = await FireRources.loadDeck<DetailedDeck>(id);
      setState(() {
        board = loadedDeck;
        isLoading = false;
      });
    } catch (exc) {
      debugPrint('! ERROR: loading deck; $exc');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban'),
        flexibleSpace: const Icon(
          Icons.view_kanban_rounded,
          color: Colours.BOTTOM,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_return_rounded),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                board!.push(Plank(id: '#'));
              });
            },
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(
            onPressed: () => {},
            //_kanbanBoard.pop(KanbanColumn(status: '...', tasks: [])),
            icon: const Icon(Icons.indeterminate_check_box_outlined),
          ),
          PopupMenuButton<TaskParameters>(
            tooltip: 'sort',
            initialValue: _buf['sort'],
            icon: const Icon(Icons.sort_rounded),
            itemBuilder: (context) => TaskParameters.values
                .map(
                  (value) =>
                      PopupMenuItem(value: value, child: Icon(value.icon())),
                )
                .toList(),
            onSelected: (TaskParameters value) {
              setState(() {
                _buf['sort'] = value;
                board!.sort(by: value);
              });
            },
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () =>
                  _switchDrawersController.show(context, Drawers.filter),
              icon: const Icon(Icons.filter_list_rounded),
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () =>
                  _switchDrawersController.show(context, Drawers.help),
              icon: const Icon(Icons.blur_on_rounded),
            ),
          ),
        ],
      ),
      endDrawer: ValueListenableBuilder(
        valueListenable: _switchDrawersController,
        builder: (context, drawer, child) => switch (drawer) {
          Drawers.help => HelpDrawer(),
          Drawers.filter => TaskFilterDrawer(
            initialFilter: board!.filterCriterias,
            onChanged: (filter) => setState(() {
              board!.filter(filter);
            }),
          ),
          _ => Drawer(),
        },
      ),
      body: Ground(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : (board == null || board!.planks.isEmpty)
            ? const Center(child: Icon(Icons.clear_rounded))
            : KanbanBoard(id: id, columns: board!),
      ),
      floatingActionButton: isLoading || board == null || board!.planks.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final docRef = FireRources.getBlocks(id).doc();
                final newBlock = Block(id: docRef.id, title: '...');
                setState(() {
                  board!.pushBlock(newBlock);
                });
                try {
                  await FireRources.saveBlock(
                    id,
                    board!.first.id,
                    newBlock,
                    board!.first.length - 1,
                  );
                } catch (exc) {
                  debugPrint('! ERROR: creating new task; $exc');
                }
              },
              child: const Icon(Icons.add_task_rounded),
            ),
    );
  }
}
