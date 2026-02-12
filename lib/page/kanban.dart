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
        title: Text('Kanban'),
        flexibleSpace: Icon(Icons.view_kanban_rounded, color: Colours.BOTTOM),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_return_rounded),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     onPressed: () => _kanbanBoard.push(
        //       KanbanColumn(status: '...', tasks: [], setState: (_) {}),
        //     ),
        //     icon: Icon(Icons.add_box_outlined),
        //   ),
        //   IconButton(
        //     onPressed: () => {},
        //     //_kanbanBoard.pop(KanbanColumn(status: '...', tasks: [])),
        //     icon: Icon(Icons.indeterminate_check_box_outlined),
        //   ),
        //   PopupMenuButton<TaskParameters>(
        //     tooltip: 'sort',
        //     initialValue: _buf['sort'],
        //     icon: Icon(Icons.sort_rounded),
        //     itemBuilder: (context) => TaskParameters.values
        //         .map(
        //           (value) =>
        //               PopupMenuItem(value: value, child: Icon(value.icon())),
        //         )
        //         .toList(),
        //     onSelected: (TaskParameters value) {
        //       setState(() => _buf['sort'] = value);
        //       _kanbanBoard.sort(by: value);
        //     },
        //   ),
        //   PopupMenuButton<TaskParameters>(
        //     tooltip: 'filter',
        //     initialValue: _buf['filter'],
        //     icon: Icon(Icons.filter_list_rounded),
        //     itemBuilder: (context) => TaskParameters.values
        //         .map(
        //           (value) =>
        //               PopupMenuItem(value: value, child: Icon(value.icon())),
        //         )
        //         .toList(),
        //     onSelected: (TaskParameters value) {
        //       setState(() => _buf['filter'] = value);
        //       showDialog(
        //         context: context,
        //         builder: (context) => switch (value) {
        //           TaskParameters.id => FilterDialog.numbers(
        //             from: _buf['from'],
        //             to: _buf['to'],
        //             onCancel: Navigator.of(context).pop,
        //             onAccept: (from, to) {
        //               _buf['from'] = from;
        //               _buf['to'] = to;
        //               _kanbanBoard.filter(
        //                 by: TaskParameters.points,
        //                 from: from,
        //                 to: to,
        //               );
        //               Navigator.of(context).pop();
        //             },
        //             icon: Icons.numbers_rounded,
        //           ),
        //           //TaskParameters.role, TaskParameters.assignee,
        //           _ => FilterDialog(
        //             values: value.parameterValues(),
        //             from: _buf['from'],
        //             to: _buf['to'],
        //             onCancel: Navigator.of(context).pop,
        //             onAccept: (from, to) {
        //               _buf['from'] = from;
        //               _buf['to'] = to;
        //               _kanbanBoard.filter(
        //                 by: TaskParameters.points,
        //                 from: from,
        //                 to: to,
        //               );
        //               Navigator.of(context).pop();
        //             },
        //             icon: Icons.numbers_rounded,
        //           ),
        //         },
        //       );
        //     },
        //   ),
        //   Builder(
        //     builder: (context) => IconButton(
        //       onPressed: Scaffold.of(context).openEndDrawer,
        //       icon: Icon(Icons.blur_on_rounded),
        //     ),
        //   ),
        // ],
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
                icon: Icon(Icons.explore_rounded),
                label: Text('Explore'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.fort_rounded),
                label: Text('Fort'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.format_paint_rounded),
                label: Text('Format paint'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.airplane_ticket_rounded),
                label: Text('Airplane ticket'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.church_rounded),
                label: Text('Church'),
              ),
            ],
          ),
        ),
      ),
      body: Ground(child: KanbanBoard(columns: board)),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _kanbanBoard.newTask,
      //   child: Icon(Icons.add_task_rounded),
      // ),
    );
  }
}
