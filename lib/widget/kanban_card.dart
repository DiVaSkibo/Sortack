import 'package:sortack/tool/_consts.dart';
import 'package:sortack/tool/_oop.dart';
import 'package:sortack/widget/_base.dart';

class KanbanCard extends StatefulWidget {
  final Task task;
  final void Function(Task what)? onDelete;

  const KanbanCard({super.key, required this.task, this.onDelete});

  KanbanCard.from({
    super.key,
    required String title,
    String? description,
    PointsTShirt? points,
    this.onDelete,
  }) : task = Task(title: title, description: description, points: points);

  @override
  State<KanbanCard> createState() => _KanbanCardState();
}

class _KanbanCardState extends State<KanbanCard> {
  late Task task = widget.task;
  late final void Function(Task what)? onDelete = widget.onDelete;
  late final _controllers = <String, TextEditingController>{};
  final _last = {};

  @override
  void initState() {
    super.initState();
    _controllers['title'] = TextEditingController(text: task.title);
    _controllers['description'] = TextEditingController(text: task.description);
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: true,
      expandedCrossAxisAlignment: CrossAxisAlignment.center,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(34),
        side: BorderSide.none,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(34),
        side: BorderSide.none,
      ),
      leading: const Icon(Icons.task_rounded),
      title: Text(task.title),
      subtitle: task.description != null ? Text(task.description!) : null,
      trailing: Text(task.points != null ? task.points!.name.toString() : '?'),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: TaskParameters.values
              .map((value) => Icon(value.icon(), color: Colours.CENTER))
              .toList(),
        ),
      ],
    );
  }
}
