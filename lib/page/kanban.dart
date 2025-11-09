import 'package:flutter/material.dart';
import 'package:sortack/tool/_constants.dart';
import 'package:sortack/tool/_palette.dart';
import 'package:sortack/elements/kanban_card.dart';
import 'package:sortack/elements/kanban_column.dart';

class KanbanPage extends StatefulWidget {
  const KanbanPage({super.key});

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  final List<KanbanColumn> kanbans = <KanbanColumn>[
    KanbanColumn(
      status: 'To Do',
      color: Colors.redAccent,
      tasks: <KanbanCard>[
        KanbanCard(
          title: 'Database',
          description: 'Architecture and build database using Firebase',
          points: PointsTShirt.XL,
        ),
        KanbanCard(
          title: 'Search system',
          description:
              'Search for available libraries for search system\nIf nothing, make by ourself',
          points: PointsTShirt.L,
        ),
      ],
    ),
    KanbanColumn(
      status: 'In Progress',
      color: Colors.yellowAccent,
      tasks: [
        KanbanCard(
          title: 'Sign In page',
          description: 'Create sign in page according to design in Figma',
          points: PointsTShirt.S,
        ),
      ],
    ),
    KanbanColumn(
      status: 'Done',
      color: Colors.greenAccent,
      tasks: [
        KanbanCard(
          title: 'Sign In page design',
          description: 'Design sign in page using Figma',
          points: PointsTShirt.L,
        ),
        KanbanCard(title: 'What', description: 'What actually do'),
        KanbanCard(
          title: 'Who',
          description: 'Who actually do',
          points: PointsTShirt.XXL,
          onDelete: (what) {},
        ),
      ],
    ),
  ];

  final _task = {};
  AlertDialog _dialog() => AlertDialog(
    backgroundColor: Palette.BG,
    surfaceTintColor: Palette.FG_ACCENT,
    icon: Icon(
      Icons.precision_manufacturing,
      size: 40,
      color: Palette.FG_SHADOW,
    ),
    content: SizedBox(
      width: 450,
      child: Wrap(
        spacing: 25,
        runSpacing: 25,
        children: <Widget>[
          TextField(
            controller: TextEditingController(),
            onChanged: (value) {
              _task['title'] = value;
            },
            decoration: InputDecoration(labelText: 'Title:'),
          ),
          TextFormField(
            controller: TextEditingController(),
            onChanged: (value) {
              _task['description'] = value;
            },
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(labelText: 'Description:'),
          ),
          DropdownButtonFormField(
            items: List<DropdownMenuItem<PointsTShirt>>.generate(
              PointsTShirt.values.length,
              (index) => DropdownMenuItem(
                value: PointsTShirt.values[index],
                child: Text(PointsTShirt.values[index].name),
              ),
            ),
            onChanged: (value) {
              _task['points'] = value;
            },
            decoration: InputDecoration(labelText: 'Points:'),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.cancel_rounded),
      ),
      IconButton(
        onPressed: () {
          if (!_task.containsKey('title')) return;
          kanbans.first.push(
            KanbanCard(
              title: _task['title'],
              description: _task['description'],
              points: _task['points'],
            ),
          );
          _task.clear();
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.create),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomCenter,
            radius: 1.0,
            colors: [Palette.BG_SHADOW, Palette.BG],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 25,
          children: kanbans,
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () =>
            showDialog(context: context, builder: (context) => _dialog()),
        icon: Icon(Icons.add),
      ),
    );
  }
}
