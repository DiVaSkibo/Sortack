import 'package:flutter/material.dart';
import 'package:sortack/tool/_palette.dart';
import 'package:sortack/tool/_constants.dart';

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

  final _last = {};
  AlertDialog _dialog() => AlertDialog(
    backgroundColor: Palette.BG,
    surfaceTintColor: Palette.FG_ACCENT,
    icon: Icon(Icons.mode_outlined, size: 40, color: Palette.FG_SHADOW),
    content: SizedBox(
      width: 450,
      child: Wrap(
        spacing: 25,
        runSpacing: 25,
        children: <Widget>[
          TextField(
            controller: TextEditingController(text: title),
            onChanged: (value) {
              _last['title'] ??= title;
              setState(() {
                title = value;
              });
            },
            decoration: InputDecoration(labelText: 'Title:'),
          ),
          TextFormField(
            controller: TextEditingController(text: description),
            onChanged: (value) {
              _last['description'] ??= description;
              setState(() {
                description = value;
              });
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
            initialValue: points,
            onChanged: (value) {
              _last['points'] ??= points;
              setState(() {
                points = value;
              });
            },
            decoration: InputDecoration(labelText: 'Points:'),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      IconButton(
        onPressed: () {
          setState(() {
            title = _last['title'] ?? title;
            description = _last['description'] ?? description;
            points = _last['points'] ?? points;
          });
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.replay_rounded),
      ),
      IconButton(
        onPressed: () {
          setState(() {
            onDelete!(widget);
          });
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.delete_forever_rounded),
      ),
    ],
  );

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
                        builder: (context) => _dialog(),
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
