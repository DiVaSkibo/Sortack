import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/_widgets.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  final TaskBoard board = TaskBoard(
    name: 'My Board',
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
          PopupMenuButton<TaskParameters>(
            tooltip: 'filter',
            initialValue: _buf['filter'],
            icon: const Icon(Icons.filter_list_rounded),
            itemBuilder: (context) => TaskParameters.values
                .map(
                  (value) =>
                      PopupMenuItem(value: value, child: Icon(value.icon())),
                )
                .toList(),
            onSelected: (TaskParameters value) {
              setState(() => _buf['filter'] = value);
              showDialog(
                context: context,
                builder: (context) => switch (value) {
                  TaskParameters.id => FilterDialog.numbers(
                    from: _buf['from'],
                    to: _buf['to'],
                    onCancel: Navigator.of(context).pop,
                    onAccept: (from, to) {
                      setState(() {
                        _buf['from'] = from;
                        _buf['to'] = to;
                        board.updateFilterCriterion(
                          parameter: value,
                          criterion: FromTo(from: from, to: to),
                        );
                      });
                      Navigator.of(context).pop();
                    },
                    icon: Icons.numbers_rounded,
                  ),
                  //
                  //TaskParameters.role, TaskParameters.assignee => ...,
                  //
                  _ => FilterDialog(
                    values: value.parameterValues(),
                    from: _buf['from'],
                    to: _buf['to'],
                    onCancel: Navigator.of(context).pop,
                    onAccept: (from, to) {
                      setState(() {
                        _buf['from'] = from;
                        _buf['to'] = to;
                        board.updateFilterCriterion(
                          parameter: value,
                          criterion: FromTo(from: from, to: to),
                        );
                      });
                      Navigator.of(context).pop();
                    },
                    icon: Icons.numbers_rounded,
                  ),
                },
              );
            },
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: Scaffold.of(context).openEndDrawer,
              icon: const Icon(Icons.blur_on_rounded),
            ),
          ),
        ],
      ),
      endDrawer: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.centerRight,
            radius: 1,
            colors: [Colours.FRONT, Colours.BACK],
          ),
        ),
        child: Drawer(
          child: ListView(
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 1,
                    colors: [Colours.BACK, Colours.UNFRONT],
                  ),
                ),
                padding: EdgeInsetsGeometry.all(0),
                child: Icon(Icons.blur_on_rounded, size: 75),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.explore_rounded),
                label: const Text('Explore'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.fort_rounded),
                label: const Text('Fort'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.format_paint_rounded),
                label: const Text('Format paint'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.airplane_ticket_rounded),
                label: const Text('Airplane ticket'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.church_rounded),
                label: const Text('Church'),
              ),
            ],
          ),
        ),
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
