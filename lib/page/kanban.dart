import 'package:sortack/tool/_consts.dart';
import 'package:sortack/elements/_base.dart';
import 'package:sortack/elements/kanban_board.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  final KanbanBoard _kanbanBoard = KanbanBoard();
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
        actions: <Widget>[
          PopupMenuButton<TaskParameters>(
            tooltip: 'sort',
            initialValue: _buf['sort'],
            icon: Icon(Icons.sort_rounded),
            itemBuilder: (context) => TaskParameters.values
                .map(
                  (value) =>
                      PopupMenuItem(value: value, child: Icon(value.icon())),
                )
                .toList(),
            onSelected: (TaskParameters value) {
              setState(() => _buf['sort'] = value);
              _kanbanBoard.sort(by: value);
            },
          ),
          PopupMenuButton<TaskParameters>(
            tooltip: 'filter',
            initialValue: _buf['filter'],
            icon: Icon(Icons.filter_list_rounded),
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
                builder: (context) => FilterDialog(
                  parameter: value,
                  from: _buf['from'],
                  to: _buf['to'],
                  onCancel: Navigator.of(context).pop,
                  onAccept: (from, to) {
                    _buf['from'] = from;
                    _buf['to'] = to;
                    _kanbanBoard.filter(
                      by: TaskParameters.points,
                      from: from,
                      to: to,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: Scaffold.of(context).openEndDrawer,
              icon: Icon(Icons.blur_on_rounded),
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
      body: Ground(child: _kanbanBoard),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => _kanbanBoard.buildTasksetDialog(),
        ),
        child: Icon(Icons.add_task_rounded),
      ),
    );
  }
}
