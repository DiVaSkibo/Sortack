import 'package:flutter/material.dart';
import 'package:sortack/tool/_constants.dart';
import 'package:sortack/tool/_palette.dart';

class FlowDialog extends StatelessWidget {
  final IconData? icon;
  final List<Widget> inputs;
  final List<Widget> actions;
  //final _buf = {};

  const FlowDialog({
    super.key,
    this.icon,
    required this.inputs,
    required this.actions,
  });

  FlowDialog.task({
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
           }),
         ),
         switch (purpose) {
           TaskFlowPurposes.create => IconButton(
             onPressed: onCreate,
             icon: Icon(Icons.create_rounded),
           ),
           TaskFlowPurposes.edit => IconButton(
             onPressed: onDelete,
             icon: Icon(Icons.delete_forever_rounded),
           ),
         },
       ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Palette.BG,
      surfaceTintColor: Palette.FG_ACCENT,
      icon: icon != null
          ? Icon(icon, size: 40, color: Palette.FG_SHADOW)
          : null,
      content: SizedBox(
        width: 450,
        child: Wrap(spacing: 25, runSpacing: 25, children: inputs),
      ),
      actions: actions,
    );
  }
}
