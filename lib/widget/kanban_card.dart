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
                      task.title,
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
                          task.points != null ? task.points!.name : '?',
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
                        builder: (context) => TasksetDialog.edit(
                          task: task,
                          onChanged: (value, prmtr) {
                            switch (prmtr) {
                              case TaskParameters.title:
                                {
                                  _last['title'] ??= task.title;
                                  setState(() {
                                    task.title = value;
                                  });
                                  break;
                                }
                              case TaskParameters.description:
                                {
                                  _last['description'] ??= task.description;
                                  setState(() {
                                    task.description = value;
                                  });
                                  break;
                                }
                              case TaskParameters.points:
                                {
                                  _last['points'] ??= task.points;
                                  setState(() {
                                    task.points = value;
                                  });
                                  break;
                                }
                              default:
                                debugPrint(
                                  '? Task edit with no task parameter case... ?',
                                );
                            }
                          },
                          onCancel: () {
                            setState(() {
                              task.title = _last['title'] ?? task.title;
                              task.description =
                                  _last['description'] ?? task.description;
                              task.points = _last['points'] ?? task.points;
                            });
                            Navigator.of(context).pop();
                          },
                          onAccept: (task) {
                            // setState(() {
                            //   onDelete!(task);
                            // });
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
                if (task.description != null)
                  Text(task.description!, style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
