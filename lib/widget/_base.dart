import 'package:sortack/tool/_consts.dart';
import 'package:sortack/tool/_oop.dart';

class Ground extends StatelessWidget {
  final Widget child;

  const Ground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: Gradients.GROUND),
      child: child,
    );
  }
}

class FilterDialog<T> extends StatelessWidget {
  final TaskParameters parameter;
  final T? from;
  final T? to;
  final Function()? onCancel;
  final Function(dynamic, dynamic)? onAccept;
  final _buf = {};

  FilterDialog({
    super.key,
    required this.parameter,
    this.from,
    this.to,
    this.onCancel,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(parameter.icon(), size: 40),
      content: SizedBox(
        width: 450,
        child: Wrap(
          spacing: 25,
          runSpacing: 25,
          children: [
            DropdownButtonFormField(
              items: List<DropdownMenuItem>.generate(
                PointsTShirt.values.length,
                (index) => DropdownMenuItem(
                  value: PointsTShirt.values[index],
                  child: Text(PointsTShirt.values[index].name),
                ),
              ),
              initialValue: from,
              onChanged: (value) {
                _buf['from'] = value;
              },
              decoration: InputDecoration(labelText: 'from'),
            ),
            Text('< x <'),
            DropdownButtonFormField(
              items: List<DropdownMenuItem>.generate(
                PointsTShirt.values.length,
                (index) => DropdownMenuItem(
                  value: PointsTShirt.values[index],
                  child: Text(PointsTShirt.values[index].name),
                ),
              ),
              initialValue: to,
              onChanged: (value) {
                _buf['to'] = value;
              },
              decoration: InputDecoration(labelText: 'to'),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: onCancel, icon: Icon(Icons.close_rounded)),
        IconButton(
          onPressed: () => _buf['from'] != null && _buf['to'] != null
              ? onAccept!(_buf['from'], _buf['to'])
              : debugPrint('\n! INTERVAL VALUES ARE NULLS !\n'),
          icon: Icon(Icons.check_rounded),
        ),
      ],
    );
  }
}

class TasksetDialog extends StatelessWidget {
  final Task task;
  final IconData? icon;
  final Function(dynamic, TaskParameters)? onChanged;
  final Function() onCancel;
  final Function(Task) onAccept;

  TasksetDialog.create({
    super.key,
    this.onChanged,
    required this.onCancel,
    required this.onAccept,
  }) : task = Task(title: ''),
       icon = Icons.precision_manufacturing_rounded;

  const TasksetDialog.edit({
    super.key,
    required this.task,
    this.onChanged,
    required this.onCancel,
    required this.onAccept,
  }) : icon = Icons.mode_outlined;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon != null ? Icon(icon, size: 40) : null,
      content: SizedBox(
        width: 450,
        child: Wrap(
          spacing: 25,
          runSpacing: 25,
          children: <Widget>[
            TextField(
              controller: TextEditingController(text: task.title),
              onChanged: (value) {
                task.title = value;
                if (onChanged != null) onChanged!(value, TaskParameters.title);
              },
              decoration: InputDecoration(labelText: 'Title:'),
            ),
            TextFormField(
              controller: TextEditingController(text: task.description),
              onChanged: (value) {
                task.description = value;
                if (onChanged != null)
                  onChanged!(value, TaskParameters.description);
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
              initialValue: task.points,
              onChanged: (value) {
                task.points = value;
                if (onChanged != null) onChanged!(value, TaskParameters.points);
              },
              decoration: InputDecoration(labelText: 'Points:'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: onCancel,
          icon: Icon(Icons.cancel_rounded, color: Colours.W),
        ),
        IconButton(
          onPressed: () => onAccept(task),
          icon: Icon(Icons.task_alt_rounded, color: Colours.W),
        ),
      ],
    );
  }
}
