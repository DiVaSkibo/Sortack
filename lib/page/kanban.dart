import 'package:flutter/material.dart';
import 'package:sortack/tool/_style.dart';
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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_return_rounded),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              onPressed: Scaffold.of(context).openEndDrawer,
              icon: Icon(Icons.blur_on_rounded),
            ),
          ),
        ],
        flexibleSpace: Icon(
          Icons.view_week_rounded,
          color: Colours.FRONT,
        ), // view_week_rounded amp_stories_rounded
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: Gradients.GROUND),
        child: _kanbanBoard,
      ),
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
