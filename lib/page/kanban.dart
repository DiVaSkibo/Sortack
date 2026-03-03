import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/_widgets.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  final DetailedTaskDeck board = DetailedTaskDeck(
    details: DeckDetails(
      name: 'My Board',
      methodology: Methodology.Kanban,
      created: DateTime.now(),
      owner: 'Me',
    ),
    listenable: true,
    planks: [
      TitledTaskPlank(
        title: 'To Do',
        color: Colours.NOTOK,
        listenable: true,
        blocks: [
          TaskBlock(
            title: 'Database',
            description: 'Architecture and build database using Firebase',
            points: TaskPointsTShirt.XL,
          ),
          TaskBlock(
            title: 'Search system',
            description:
                'Search for available libraries for search system\nIf nothing, make by ourself',
            points: TaskPointsTShirt.L,
          ),
        ],
      ),
      TitledTaskPlank(
        title: 'In Progress',
        color: Colours.INOK,
        listenable: true,
        blocks: [
          TaskBlock(
            title: 'Sign In page',
            description: 'Create sign in page according to design in Figma',
            points: TaskPointsTShirt.S,
          ),
        ],
      ),
      TitledTaskPlank(
        title: 'Done',
        color: Colours.OK,
        listenable: true,
        blocks: [
          TaskBlock(
            title: 'Sign In page design',
            description: 'Design sign in page using Figma',
            points: TaskPointsTShirt.L,
          ),
          TaskBlock(title: 'What', description: 'What actually do'),
          TaskBlock(
            title: 'Who',
            description: 'Who actually do',
            points: TaskPointsTShirt.XXL,
          ),
        ],
      ),
    ],
  );
  final SwitchDrawersController _switchDrawersController =
      SwitchDrawersController();
  final _buf = {};

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
                board.push(TitledTaskPlank());
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
                board.sort(by: value);
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
            initialFilter: board.filterCriterias,
            onChanged: (filter) => setState(() {
              board.filter(filter);
            }),
          ),
          _ => Drawer(),
        },
      ),
      body: Ground(child: KanbanBoard(columns: board)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            board.pushBlock(TaskBlock());
          });
        },
        child: const Icon(Icons.add_task_rounded),
      ),
    );
  }
}
