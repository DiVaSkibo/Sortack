import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/_widgets.dart';

class KanbanPage extends StatefulWidget {
  final ProjectDetails details;

  const KanbanPage({super.key, required this.details});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  late final Deck? board;
  Map<String, UserProfile> membersProfiles = {};
  bool _isLoading = true;

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
      // board data
      final Deck loadedDeck = await FireRources.loadDeck<Deck>(
        widget.details.id,
      );
      board = loadedDeck;
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
    final newTaskList = Plank(id: docRef.id);
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
      );
    } catch (exc) {
      debugPrint('! ERROR: on creating new tasklist; $exc');
    }
  }

  void addTask() async {
    // generate
    final docRef = FireRources.getBlocks(widget.details.id).doc();
    final newTask = Block(id: docRef.id);
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
      debugPrint('! ERROR: on creating new task; $exc');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isLoading
          ? const Overground.loading()
          : Overground(
              icon: Icons.view_kanban_rounded,
              title: widget.details.name,
              iconColor: Colours.VERY_HIGH,
              actions: [
                IconButton(
                  onPressed: () => addTaskList(),
                  icon: const Icon(
                    Icons.add_box_outlined,
                    color: Colours.UNTOP,
                  ),
                ),
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
                    icon: const Icon(
                      Icons.filter_alt_outlined,
                    ), //filter_list_rounded
                  ),
                ),
                Builder(
                  builder: (context) => IconButton(
                    onPressed: () =>
                        _switchDrawersController.show(context, Drawers.help),
                    icon: const Icon(
                      Icons.help_rounded,
                      color: Colours.UNBOTTOM,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Colours.UNFRONT,
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
        child: _isLoading
            ? Center(child: buildLoading())
            : (board == null || board!.planks.isEmpty)
            ? Center(child: buildEasterEgg(size: 90))
            : KanbanBoard(
                id: widget.details.id,
                columns: board!,
                members: membersProfiles,
              ),
      ),
      floatingActionButton: _isLoading || board == null
          ? null
          : FloatingActionButton(
              heroTag: 'btnAddTask',
              child: Icon(
                Icons.add_task_rounded,
                shadows: List.generate(
                  30,
                  (index) => Shadow(blurRadius: 1.15, color: Colours.B),
                ),
              ),
              onPressed: () => addTask(),
            ),
    );
  }
}
