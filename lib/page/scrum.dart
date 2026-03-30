import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/_widgets.dart';

class ScrumPage extends StatefulWidget {
  final String id;

  const ScrumPage({super.key, required this.id});

  @override
  State<ScrumPage> createState() => _ScrumPageState();
}

class _ScrumPageState extends State<ScrumPage>
    with SingleTickerProviderStateMixin {
  late final AdvancedDeck? board;
  bool isLoading = true;
  late TabController _tabController;

  final SwitchDrawersController _switchDrawersController =
      SwitchDrawersController();
  final _buf = {};

  @override
  void initState() {
    super.initState();
    _loadData();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _switchDrawersController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final AdvancedDeck loadedDeck = await FireRources.loadDeck<AdvancedDeck>(
        widget.id,
      );
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
        title: const Text('Scrum'),
        flexibleSpace: const Icon(Icons.cyclone_rounded, color: Colours.BOTTOM),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.keyboard_return_rounded),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                board!.push(AdvancedPlank(id: '#'));
              });
            },
            icon: const Icon(Icons.add_box_outlined),
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
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.production_quantity_limits_rounded)),
            Tab(icon: Icon(Icons.swap_horizontal_circle_outlined)),
            Tab(icon: Icon(Icons.text_increase_rounded)),
          ],
        ),
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
            : TabBarView(
                controller: _tabController,
                children: [
                  ScrumBoard(id: widget.id, tables: board!, selectedIndex: 0),
                  ScrumBoard(id: widget.id, tables: board!, selectedIndex: 1),
                  Row(
                    children: [
                      Icon(Icons.text_increase_rounded),
                      Text('INCREMENT'),
                    ],
                  ), //ScrumBoard(id: widget.id, tables: board!, selectedIndex: 2),
                ],
              ),
      ),
      floatingActionButton: isLoading || board == null || board!.planks.isEmpty
          ? null
          : switch (_tabController.index) {
              0 => FloatingActionButton(
                onPressed: () async {
                  final docRef = FireRources.getBlocks(widget.id).doc();
                  final newBlock = AdvancedBlock(id: docRef.id, title: '...');
                  setState(() {
                    board!.pushBlock(newBlock);
                  });
                  try {
                    await FireRources.saveBlock(
                      widget.id,
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
              1 => FloatingActionButton(
                onPressed: () async {
                  final docRef = FireRources.getBlocks(widget.id).doc();
                  final newBlock = AdvancedBlock(id: docRef.id, title: '...');
                  setState(() {
                    board!.pushBlock(newBlock);
                  });
                  try {
                    await FireRources.saveBlock(
                      widget.id,
                      board!.first.id,
                      newBlock,
                      board!.first.length - 1,
                    );
                  } catch (exc) {
                    debugPrint('! ERROR: creating new task; $exc');
                  }
                },
                child: const Icon(Icons.add_business_rounded),
              ),
              2 => null,
              _ => null,
            },
    );
  }
}
