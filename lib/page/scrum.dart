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
  late final AdvancedMapDeck? board = AdvancedMapDeck(
    selectedKey: SCRUM_KEYS.first,
    maplanks: {
      'Product Backlog': [
        AdvancedPlank(
          id: '!',
          title: 'Product Backlog',
          blocks: [
            AdvancedBlock(id: '!', title: '1'),
            AdvancedBlock(id: '@', title: '22'),
            AdvancedBlock(id: '#', title: '333'),
            AdvancedBlock(id: '%', title: '4444'),
            AdvancedBlock(id: '^', title: '55555'),
          ],
        ),
      ],
      'Sprint Backlog': [
        AdvancedPlank(
          id: '@',
          title: 'Sprint-1',
          blocks: [
            AdvancedBlock(id: '@', title: '22'),
            AdvancedBlock(id: '%', title: '4444'),
          ],
        ),
        AdvancedPlank(
          id: '#',
          title: 'Sprint-2',
          blocks: [AdvancedBlock(id: '!', title: '1')],
        ),
        AdvancedPlank(
          id: '%',
          title: 'Sprint-3',
          blocks: [
            AdvancedBlock(id: '^', title: '55555'),
            AdvancedBlock(id: '#', title: '333'),
          ],
        ),
      ],
      'Increments': [
        AdvancedPlank(
          id: '^',
          title: 'Increment-1',
          blocks: [
            AdvancedBlock(id: '@', title: '22'),
            AdvancedBlock(id: '%', title: '4444'),
          ],
        ),
        AdvancedPlank(
          id: '&',
          title: 'Increment-2',
          blocks: [AdvancedBlock(id: '!', title: '1')],
        ),
      ],
    },
  );
  bool isLoading = false;
  late TabController _tabController;

  final SwitchDrawersController _switchDrawersController =
      SwitchDrawersController();
  final _buf = {};

  @override
  void initState() {
    super.initState();
    //_loadData();
    _tabController = TabController(length: SCRUM_KEYS.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        board!.selectedKey = SCRUM_KEYS[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _switchDrawersController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Future<void> _loadData() async {
  //   try {
  //     final AdvancedDeck loadedDeck = await FireRources.loadDeck<AdvancedDeck>(
  //       widget.id,
  //     );
  //     setState(() {
  //       board = loadedDeck;
  //       isLoading = false;
  //     });
  //   } catch (exc) {
  //     debugPrint('! ERROR: loading deck; $exc');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

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
                children: SCRUM_KEYS
                    .map(
                      (key) => ScrumBoard(
                        id: widget.id,
                        tables: board!,
                        selectedKey: key,
                      ),
                    )
                    .toList(),
              ),
      ),
      floatingActionButton: isLoading || board == null || board!.planks.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final docRef = FireRources.getBlocks(widget.id).doc();
                final newBlock = AdvancedBlock(id: docRef.id, title: '...');
                setState(() {
                  board!.pushBlock(newBlock);
                });
                try {
                  await FireRources.saveBlock(
                    widget.id,
                    board![_tabController.index].id,
                    newBlock,
                    board![_tabController.index].length,
                  );
                  debugPrint('${board![_tabController.index].length - 1}');
                } catch (exc) {
                  debugPrint('! ERROR: creating new task; $exc');
                }
              },
              child: const Icon(Icons.add_task_rounded),
            ),
    );
  }
}
