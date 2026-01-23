import 'package:sortack/tool/_constants.dart';

class Task {
  final int id;
  String title;
  String? description;
  Status? status;
  PriorityLevel? priority;
  PointsTShirt? points;
  String? role;
  String? assignee;
  String? notes;

  Task({
    int? id,
    required this.title,
    this.description,
    this.status,
    this.priority,
    this.points,
    this.role,
    this.assignee,
    this.notes,
  }) : id = id ?? Random().nextInt(1000);
}
