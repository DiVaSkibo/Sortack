import 'package:sortack/tool/_constants.dart';
import 'package:sortack/tool/_classes.dart';
import 'package:sortack/tool/_style.dart';
import 'package:sortack/elements/_base.dart';

class KanbanCard extends StatefulWidget {
  final Task data;
  final void Function(Task what)? onDelete;

  const KanbanCard({super.key, required this.data, this.onDelete});

  KanbanCard.from({
    super.key,
    required String title,
    String? description,
    PointsTShirt? points,
    this.onDelete,
  }) : data = Task(title: title, description: description, points: points);

  @override
  State<KanbanCard> createState() => _KanbanCardState();
}

class _KanbanCardState extends State<KanbanCard> {
  late Task data = widget.data;
  late final void Function(Task what)? onDelete = widget.onDelete;
  late final _controllers = <String, TextEditingController>{};
  final _last = {};

  @override
  void initState() {
    super.initState();
    _controllers['title'] = TextEditingController(text: data.title);
    _controllers['description'] = TextEditingController(text: data.description);
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
    //     ListTile(
    //       title: Text(
    //         tasks[taskIndex],
    //         style: const TextStyle(color: Colors.white),
    //       ),
    //       leading: const Icon(
    //         Icons.circle,
    //         color: Colors.yellow,
    //       ), // Твій циліндр
    //     ),
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        //color: Colours.FG,
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
                      data.title,
                      style: TextStyle(fontWeight: FontWeight.w500),
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
                          data.points != null ? data.points!.name : '?',
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Colours.CENTER,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => FlowDialog.task(
                          purpose: TaskFlowPurposes.edit,
                          title: data.title,
                          description: data.description,
                          points: data.points,
                          onTitleChanged: (value) {
                            _last['title'] ??= data.title;
                            setState(() {
                              data.title = value;
                            });
                          },
                          onDescriptionChanged: (value) {
                            _last['description'] ??= data.description;
                            setState(() {
                              data.description = value;
                            });
                          },
                          onPointsChanged: (value) {
                            _last['points'] ??= data.points;
                            setState(() {
                              data.points = value;
                            });
                          },
                          onCancel: () {
                            setState(() {
                              data.title = _last['title'] ?? data.title;
                              data.description =
                                  _last['description'] ?? data.description;
                              data.points = _last['points'] ?? data.points;
                            });
                            Navigator.of(context).pop();
                          },
                          onDelete: () {
                            setState(() {
                              onDelete!(data);
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      icon: Icon(Icons.more_vert),
                      iconSize: 17,
                      padding: EdgeInsets.all(0),
                      color: Colours.UNFRONT,
                      style: IconButton.styleFrom(minimumSize: Size(5, 5)),
                    ),
                  ],
                ),
                if (data.description != null)
                  Text(data.description!, style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
