import 'package:sortack/tool/_constants.dart';
import 'package:sortack/tool/_style.dart';
import 'package:sortack/elements/_base.dart';
import 'package:sortack/elements/kanban_board.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  final KanbanBoard _kanbanBoard = KanbanBoard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kanban'),
        flexibleSpace: Icon(
          Icons.view_kanban_rounded,
          color: Colours.BOTTOM,
        ), // view_week_rounded amp_stories_rounded
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_return_rounded),
        ),
        actions: <Widget>[
          PopupMenuButton(
            tooltip: 'sort',
            initialValue: TaskParameters.id,
            icon: Icon(Icons.sort_rounded),
            itemBuilder: (context) => popupTaskParametersMenu(),
            onSelected: (TaskParameters value) => _kanbanBoard.sort(by: value),
          ),
          PopupMenuButton(
            tooltip: 'filter',
            initialValue: TaskParameters.id,
            icon: Icon(Icons.filter_list_rounded),
            itemBuilder: (context) => popupTaskParametersMenu(),
            onSelected: (TaskParameters value) => showDialog(
              context: context,
              builder: (context) => FlowDialog.filter(
                parameter: TaskParameters.points,
                points: PointsTShirt.S,
                onValueChanged: (value) => {},
                onCancel: Navigator.of(context).pop,
                onAccept: (from, to) => _kanbanBoard.filter(
                  by: TaskParameters.points,
                  from: from,
                  to: to,
                ),
              ),
            ),
            // (TaskParameters value) => _kanbanBoard.filter(by: value),
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
          builder: (context) => _kanbanBoard.buildFlowDialog(),
        ),
        child: Icon(Icons.add_task_rounded),
      ),
    );
  }
}
