import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/_widgets.dart';

class ScrumPage extends StatefulWidget {
  final ProjectDetails details;

  const ScrumPage({super.key, required this.details});

  @override
  State<ScrumPage> createState() => _ScrumPageState();
}

class _ScrumPageState extends State<ScrumPage>
    with SingleTickerProviderStateMixin {
  late final AdvancedMapDeck? board;
  Map<String, UserProfile> membersProfiles = {};
  late TabController _tabController;
  bool _isLoading = true;

  final SwitchDrawersController _switchDrawersController =
      SwitchDrawersController();
  final _buf = {};

  @override
  void initState() {
    super.initState();
    _loadData();
    _tabController = TabController(length: SCRUM_KEYS.length, vsync: this);
    _tabController.addListener(() {
      var newKey = SCRUM_KEYS[_tabController.index];
      if (board!.selectedKey == newKey) return;
      setState(() {
        board!.selectedKey = newKey;
      });
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
      final AdvancedMapDeck loadedMapDeck =
          await FireRources.loadMapDeck<AdvancedMapDeck>(
            widget.details.id,
            keys: SCRUM_KEYS,
          );
      board = loadedMapDeck;
      board!.selectedKey = SCRUM_KEYS.first;
      Map<String, UserProfile> loadedProfiles = {};
      for (String uid in widget.details.members) {
        final profile = await FireRources.loadUserProfile(uid);
        if (profile != null) loadedProfiles[uid] = profile;
      }
      if (!mounted) return;
      membersProfiles = loadedProfiles;
    } catch (exc) {
      debugPrint('! ERROR: on loading data; $exc');
    } finally {
      setState(() {
        _isLoading = false;
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
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : (board == null || board!.planks.isEmpty)
            ? const Center(child: Icon(Icons.clear_rounded))
            : TabBarView(
                controller: _tabController,
                children: board!.values
                    .map(
                      (value) => ScrumBoard(
                        id: widget.details.id,
                        tables: value,
                        members: membersProfiles,
                      ),
                    )
                    .toList(),
              ),
      ),
      floatingActionButton: _isLoading || board == null || board!.planks.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final docRef = FireRources.getBlocks(widget.details.id).doc();
                final newBlock = AdvancedBlock(id: docRef.id, title: '...');
                setState(() {
                  board!.pushBlock(newBlock);
                });
                try {
                  await FireRources.saveBlock(
                    widget.details.id,
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
