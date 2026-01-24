import 'package:flutter/foundation.dart';
import 'package:sortack/tool/_consts.dart';

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
  final IconData? icon;
  final List<Widget> inputs;
  final List<Widget> actions;
  final _buf = {};

  TasksetDialog({
    super.key,
    this.icon,
    required this.inputs,
    required this.actions,
  });

  TasksetDialog.task({
    super.key,
    required TaskFlowPurposes purpose,
    String? title,
    String? description,
    PointsTShirt? points,
    Function(String value)? onTitleChanged,
    Function(String value)? onDescriptionChanged,
    Function(PointsTShirt? value)? onPointsChanged,
    Function()? onCancel,
    Function()? onCreate,
    Function()? onDelete,
  }) : icon = switch (purpose) {
         TaskFlowPurposes.create => Icons.precision_manufacturing_rounded,
         TaskFlowPurposes.edit => Icons.mode_outlined,
       },
       inputs = <Widget>[
         TextField(
           controller: TextEditingController(text: title),
           onChanged: onTitleChanged,
           decoration: InputDecoration(labelText: 'Title:'),
         ),
         TextFormField(
           controller: TextEditingController(text: description),
           onChanged: onDescriptionChanged,
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
           initialValue: points,
           onChanged: onPointsChanged,
           decoration: InputDecoration(labelText: 'Points:'),
         ),
       ],
       actions = <Widget>[
         IconButton(
           onPressed: onCancel,
           icon: Icon(switch (purpose) {
             TaskFlowPurposes.create => Icons.cancel_rounded,
             TaskFlowPurposes.edit => Icons.replay_rounded,
           }, color: Colours.W),
         ),
         switch (purpose) {
           TaskFlowPurposes.create => IconButton(
             onPressed: onCreate,
             icon: Icon(Icons.task_alt_rounded, color: Colours.W),
           ),
           TaskFlowPurposes.edit => IconButton(
             onPressed: onDelete,
             icon: Icon(Icons.delete_forever_rounded, color: Colours.W),
           ),
         },
       ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon != null ? Icon(icon, size: 40) : null,
      content: SizedBox(
        width: 450,
        child: Wrap(spacing: 25, runSpacing: 25, children: inputs),
      ),
      actions: actions,
    );
  }
}
