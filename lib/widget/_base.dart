import 'package:sortack/tool/_consts.dart';
import 'package:sortack/tool/_oop.dart';

/// ground widget - filled page background
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

/// task controller - control task parameters
class TaskController {
  final Task task;
  final TextEditingController _titleController;
  final TextEditingController _descriptionController;
  final TextEditingController _notesController;
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _notesFocus = FocusNode();
  void Function(void Function()) setState;

  TaskController(this.task, {required this.setState})
    : _titleController = TextEditingController(text: task.title),
      _descriptionController = TextEditingController(text: task.description),
      _notesController = TextEditingController(text: task.notes) {
    _titleFocus.addListener(() {
      if (!_titleFocus.hasFocus)
        setState(() {
          task.title = _titleController.text;
          debugPrint(
            'Task title:\n"${task.title}"\n\t("${_titleController.text}")',
          );
        });
    });
    _descriptionFocus.addListener(() {
      if (!_descriptionFocus.hasFocus)
        setState(() {
          task.description = _descriptionController.text;
          debugPrint(
            'Task description:\n"${task.description}"\n\t("${_descriptionController.text}")',
          );
        });
    });
    _notesFocus.addListener(() {
      if (!_notesFocus.hasFocus)
        setState(() {
          task.notes = _notesController.text;
          debugPrint(
            'Task notes:\n"${task.notes}"\n\t("${_notesController.text}")',
          );
        });
    });
  }

  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _notesFocus.dispose();
  }

  TextField buildTitleField() => TextField(
    controller: _titleController,
    focusNode: _titleFocus,
    onEditingComplete: () => _titleFocus.unfocus(),
    onTapOutside: (event) => _titleFocus.unfocus(),
  );
  TextFormField buildDescriptionField() => TextFormField(
    controller: _descriptionController,
    focusNode: _descriptionFocus,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 3,
    onTapOutside: (event) => _descriptionFocus.unfocus(),
  );
  PopupMenuButton buildPointsField() => PopupMenuButton<PointsTShirt>(
    tooltip: 'points',
    initialValue: task.points,
    child: Text(task.points != null ? task.points!.name.toString() : '?'),
    itemBuilder: (context) => PointsTShirt.values
        .map((value) => PopupMenuItem(value: value, child: Text(value.name)))
        .toList(),
    onSelected: (PointsTShirt value) {
      setState(() {
        task.points = value;
      });
    },
  );
}

/// accept dialog widget - dialog for accept action
class AcceptDialog extends StatelessWidget {
  final String? message;
  final Function()? onCancel;
  final Function()? onAccept;
  final IconData? icon;

  const AcceptDialog({
    super.key,
    this.message,
    required this.onCancel,
    required this.onAccept,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon != null ? Icon(icon, size: 40) : null,
      content: Text(message ?? 'are you sure?...'),
      actions: [
        IconButton(onPressed: onCancel, icon: Icon(Icons.close_rounded)),
        IconButton(onPressed: onAccept, icon: Icon(Icons.check_rounded)),
      ],
    );
  }
}

/// filter dialog widget - dialog for tasks filtering by parameter
class FilterDialog extends StatelessWidget {
  final List values;
  dynamic from;
  dynamic to;
  final Function()? onCancel;
  final Function(dynamic, dynamic)? onAccept;
  final IconData? icon;
  late Widget fromField;
  late Widget toField;

  FilterDialog({
    super.key,
    required this.values,
    this.from,
    this.to,
    this.onCancel,
    this.onAccept,
    this.icon,
  }) {
    fromField = DropdownButtonFormField(
      items: List<DropdownMenuItem>.generate(
        values.length,
        (index) => DropdownMenuItem(
          value: values[index],
          child: Text(values[index].name),
        ),
      ),
      initialValue: from,
      onChanged: (value) {
        from = value;
      },
      decoration: InputDecoration(labelText: 'from'),
    );
    toField = DropdownButtonFormField(
      items: List<DropdownMenuItem>.generate(
        values.length,
        (index) => DropdownMenuItem(
          value: values[index],
          child: Text(values[index].name),
        ),
      ),
      initialValue: to,
      onChanged: (value) {
        to = value;
      },
    );
  }

  FilterDialog.numbers({
    super.key,
    this.from,
    this.to,
    this.onCancel,
    this.onAccept,
    this.icon,
  }) : values = [] {
    fromField = TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      controller: TextEditingController(text: from),
      onChanged: (value) {
        from = value;
      },
      decoration: InputDecoration(labelText: 'from'),
    );
    toField = TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      controller: TextEditingController(text: to),
      onChanged: (value) {
        to = value;
      },
      decoration: InputDecoration(labelText: 'from'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon != null ? Icon(icon, size: 40) : null,
      content: SizedBox(
        width: 450,
        child: Wrap(
          spacing: 25,
          runSpacing: 25,
          children: [fromField, Text('< x <'), toField],
        ),
      ),
      actions: [
        IconButton(onPressed: onCancel, icon: Icon(Icons.close_rounded)),
        IconButton(
          onPressed: () => from != null && to != null
              ? onAccept!(from, to)
              : debugPrint('\n! INTERVAL VALUES ARE NULLS !\n'),
          icon: Icon(Icons.check_rounded),
        ),
      ],
    );
  }
}

/// taskset dialog widget - dialog for setting task parameters
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
