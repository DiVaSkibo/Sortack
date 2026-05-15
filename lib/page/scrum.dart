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
  late final AdvancedMapDeck<ScrumArtefact>? board;
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
    // tab controller
    _tabController = TabController(
      length: ScrumArtefact.values.length,
      vsync: this,
    );
    _tabController.addListener(() {
      var newKey = ScrumArtefact.values[_tabController.index];
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
      // board data
      final AdvancedMapDeck<ScrumArtefact> loadedMapDeck =
          await FireRources.loadMapDeck<
            AdvancedMapDeck<ScrumArtefact>,
            ScrumArtefact
          >(widget.details.id);
      if (loadedMapDeck.decks[ScrumArtefact.increments] != null &&
          loadedMapDeck.decks[ScrumArtefact.increments]!.isNotEmpty)
        for (final plank
            in loadedMapDeck.decks[ScrumArtefact.increments]!.planks)
          for (final block in plank.blocks) block.enabled = false;
      //
      // ?????????????
      var productPlank =
          loadedMapDeck.decks[ScrumArtefact.productBacklog]!.first;
      final sprintDeck = loadedMapDeck.decks[ScrumArtefact.sprintBacklog]!;
      final incrementDeck = loadedMapDeck.decks[ScrumArtefact.increments]!;
      for (final plank in sprintDeck.planks)
        for (final block in plank.blocks) productPlank.push(block, 0);
      for (final plank in incrementDeck.planks)
        for (final block in plank.blocks) productPlank.push(block);
      // ?????????????
      //
      board = loadedMapDeck;
      board!.selectedKey = ScrumArtefact.productBacklog;
      // profiles data
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

  void addTaskList() async {
    // generate
    final docRef = FireRources.getPlanks(widget.details.id).doc();
    final newTaskList = AdvancedPlank(
      id: docRef.id,
      title: 'Sprint ${DateTime.now().ddMMMyyyy}',
      color: board!.selectedKey!.colour,
    );
    // display
    setState(() {
      board!.push(newTaskList);
    });
    // fire
    try {
      await FireRources.savePlank(
        widget.details.id,
        newTaskList,
        board!.length - 1,
        key: board!.selectedKey!.label,
      );
    } catch (exc) {
      debugPrint('! ERROR: creating new tasklist; $exc');
    }
  }

  void addTask() async {
    // generate
    final docRef = FireRources.getBlocks(widget.details.id).doc();
    final newTask = AdvancedBlock(id: docRef.id);
    // check if no tasklists
    if (board!.isEmpty) addTaskList();
    // display
    setState(() {
      board!.pushBlock(newTask);
    });
    // fire
    try {
      await FireRources.saveBlock(
        widget.details.id,
        board!.first.id,
        newTask,
        board!.first.length - 1,
      );
    } catch (exc) {
      debugPrint('! ERROR: creating new task; $exc');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isLoading
          ? const Overground.loading()
          : Overground(
              icon: Icons.change_circle_rounded,
              iconColor: Colours.VERY_LOW,
              title: widget.details.name,
              actions: [
                PopupMenuButton<TaskParameters>(
                  tooltip: 'sort',
                  initialValue: _buf['sort'],
                  icon: const Icon(Icons.sort_rounded),
                  itemBuilder: (context) => TaskParameters.values
                      .map(
                        (value) => PopupMenuItem(
                          value: value,
                          child: Icon(value.icon()),
                        ),
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
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                ),
                Builder(
                  builder: (context) => IconButton(
                    onPressed: () =>
                        _switchDrawersController.show(context, Drawers.help),
                    icon: const Icon(
                      Icons.help_rounded,
                      color: Colours.ANCHOR_UN,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Colours.INK_UN,
                  ),
                ),
              ],
              tabController: _tabController,
              tabIcons: ScrumArtefact.values
                  .map((artefact) => artefact.icon)
                  .toList(),
              tabTitles: ScrumArtefact.values
                  .map((artefact) => artefact.label)
                  .toList(),
              onRender: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScrumPage(details: widget.details),
                  ),
                );
              },
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
        over: true,
        tabs: true,
        child: _isLoading
            ? Center(child: buildLoading())
            : (board == null || board!.planks.isEmpty)
            ? Center(child: buildEasterEgg())
            : TabBarView(
                controller: _tabController,
                children: board!.entries
                    .map(
                      (entry) => ScrumBoard(
                        id: widget.details.id,
                        tables: entry.value,
                        nextTables: board!.decks[entry.key.next]!,
                        members: membersProfiles,
                        artefact: entry.key,
                      ),
                    )
                    .toList(),
              ),
      ),
      floatingActionButton: _isLoading || board == null
          ? null
          : switch (board!.selectedKey) {
              ScrumArtefact.productBacklog => FloatingActionButton(
                heroTag: 'btnAddTask',
                child: Icon(
                  Icons.add_task_rounded,
                  shadows: List.generate(
                    30,
                    (index) => const Shadow(blurRadius: 1.15, color: Colours.O),
                  ),
                ),
                onPressed: () => addTask(),
              ),
              ScrumArtefact.sprintBacklog => FloatingActionButton(
                heroTag: 'btnAddSprint',
                child: Icon(
                  Icons.add_card_rounded,
                  shadows: List.generate(
                    30,
                    (index) => const Shadow(blurRadius: 1.15, color: Colours.O),
                  ),
                ),
                onPressed: () => addTaskList(),
              ),
              _ => null,
            },
    );
  }
}
