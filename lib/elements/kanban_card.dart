import 'package:flutter/material.dart';
import 'package:sortack/tool/_constants.dart';
import 'package:sortack/tool/_style.dart';
import 'package:sortack/elements/_base.dart';

class KanbanCard extends StatefulWidget {
  final String title;
  final String? description;
  final PointsTShirt? points;
  final void Function(KanbanCard what)? onDelete;

  const KanbanCard({
    super.key,
    required this.title,
    this.description,
    this.points,
    this.onDelete,
  });

  @override
  State<KanbanCard> createState() => _KanbanCardState();
}

class _KanbanCardState extends State<KanbanCard> {
  late String title = widget.title;
  late String? description = widget.description;
  late PointsTShirt? points = widget.points;
  late final void Function(KanbanCard what)? onDelete = widget.onDelete;
  late final _controllers = <String, TextEditingController>{};
  final _last = {};

  @override
  void initState() {
    super.initState();
    _controllers['title'] = TextEditingController(text: title);
    _controllers['description'] = TextEditingController(text: description);
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
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        //color: Palette.FG,
        //borderRadius: BorderRadius.all(Radius.elliptical(20, 15)),
        image: DecorationImage(
          image: AssetImage('assets/icon/Tasktack.png'),
          fit: BoxFit.fitWidth,
          alignment: AlignmentGeometry.topCenter,
        ),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 47),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icon/Estimate.png'),
                        ),
                        //shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          points != null ? points!.name : '?',
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Palette.FG_ACCENT,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => FlowDialog.task(
                          purpose: TaskFlowPurposes.edit,
                          title: title,
                          description: description,
                          points: points,
                          onTitleChanged: (value) {
                            _last['title'] ??= title;
                            setState(() {
                              title = value;
                            });
                          },
                          onDescriptionChanged: (value) {
                            _last['description'] ??= description;
                            setState(() {
                              description = value;
                            });
                          },
                          onPointsChanged: (value) {
                            _last['points'] ??= points;
                            setState(() {
                              points = value;
                            });
                          },
                          onCancel: () {
                            setState(() {
                              title = _last['title'] ?? title;
                              description = _last['description'] ?? description;
                              points = _last['points'] ?? points;
                            });
                            Navigator.of(context).pop();
                          },
                          onDelete: () {
                            setState(() {
                              onDelete!(widget);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      icon: Icon(Icons.more_vert),
                      iconSize: 17,
                      padding: EdgeInsets.all(0),
                      color: Palette.FG_SHADOW,
                      style: IconButton.styleFrom(minimumSize: Size(5, 5)),
                    ),
                  ],
                ),
                if (description != null)
                  Text(
                    description!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
