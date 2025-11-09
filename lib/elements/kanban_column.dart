import 'package:flutter/material.dart';
import 'package:sortack/tool/_palette.dart';
import 'package:sortack/elements/kanban_card.dart';

class KanbanColumn extends StatefulWidget {
  final String status;
  final List<KanbanCard>? tasks;
  final Color? color;

  void push(KanbanCard what) => _kanbanColumnState!.push(what);

  KanbanColumn({super.key, required this.status, this.tasks, this.color});

  _KanbanColumnState? _kanbanColumnState;
  @override
  State<KanbanColumn> createState() {
    _kanbanColumnState = _KanbanColumnState();
    return _kanbanColumnState!;
  }
}

class _KanbanColumnState extends State<KanbanColumn> {
  late final String status = widget.status;
  late final List<KanbanCard> tasks = widget.tasks ?? [];
  late final Color color = widget.color ?? Colors.white;
  late Function pus = widget.push;

  @override
  void initState() {
    pus = (what) => push(what);
    super.initState();
  }

  void push(KanbanCard what) {
    setState(() {
      tasks.add(
        KanbanCard(
          title: what.title,
          description: what.description,
          points: what.points,
          onDelete: (task) => pop(task),
        ),
      );
    });
  }

  void pop(KanbanCard what) {
    setState(() {
      tasks.remove(what);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 15,
      children: <Widget>[
        Text(
          status,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          height: MediaQuery.of(context).size.height / 1.25,
          padding: EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Palette.BG_SHADOW,
            borderRadius: BorderRadius.all(Radius.elliptical(40, 30)),
          ),
          child: Column(spacing: 10, children: tasks),
        ),
      ],
    );
  }
}
