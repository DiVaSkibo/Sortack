import 'dart:math';
export 'dart:math';
import 'package:sortack/tool/_style.dart';
export 'package:sortack/tool/_style.dart';

/// task status enum - task statuses
///
/// [to do, in progress, done]
enum TaskStatus implements Comparable<TaskStatus> {
  toDo,
  inProgress,
  done;

  Color colour() => switch (this) {
    toDo => Colours.NOTOK,
    inProgress => Colours.INOK,
    done => Colours.OK,
  };

  @override
  int compareTo(TaskStatus other) => index - other.index;
}

/// task priority enum - task priority levels
///
/// [critical, very high, high, medium, low, very low]
enum TaskPriority implements Comparable<TaskPriority> {
  critical,
  very_high,
  high,
  medium,
  low,
  very_low;

  Color colour() => switch (this) {
    critical => Colours.NOTOK,
    very_high => Colours.NOTOK,
    high => Colours.NOTOK,
    medium => Colours.INOK,
    low => Colours.OK,
    very_low => Colours.BOTTOM,
  };

  @override
  int compareTo(TaskPriority other) => index - other.index;
}

/// task fibonacci points enum - task points using fibonacci system
///
/// [0, 1, 2, 3, 5, 8, 13, 20, 40, 100]
enum TaskPointsFibonacci implements Comparable<TaskPointsFibonacci> {
  X0,
  X1,
  X2,
  X3,
  X5,
  X8,
  X13,
  X20,
  X40,
  X100;

  @override
  int compareTo(TaskPointsFibonacci other) => index - other.index;
}

/// task tshirt points enum - task points using tshirt system
///
/// [XS, S, M, L, XL, XXL]
enum TaskPointsTShirt implements Comparable<TaskPointsTShirt> {
  XS,
  S,
  M,
  L,
  XL,
  XXL;

  @override
  int compareTo(TaskPointsTShirt other) => index - other.index;
}

/// task parameters enum - parameters of a task class
///
/// [id, title, description, status, priority, points, role, assignee, notes]
enum TaskParameters {
  id,
  title,
  description,
  status,
  priority,
  points,
  role,
  assignee,
  notes;

  Type type() => switch (this) {
    id => int,
    title => String,
    description => String,
    status => TaskStatus,
    priority => TaskPriority,
    points => TaskPointsTShirt,
    role => String,
    assignee => String,
    notes => String,
  };

  List parameterValues() => switch (this) {
    TaskParameters.id => [],
    TaskParameters.title => [],
    TaskParameters.description => [],
    TaskParameters.status => TaskStatus.values,
    TaskParameters.priority => TaskPriority.values,
    TaskParameters.points => TaskPointsTShirt.values,
    TaskParameters.role => [],
    TaskParameters.assignee => [],
    TaskParameters.notes => [],
  };

  IconData icon() => switch (this) {
    id => Icons.numbers_rounded,
    title => Icons.title_rounded,
    description => Icons.text_fields_rounded,
    status => Icons.air_rounded,
    priority => Icons.priority_high_rounded,
    points => Icons.adjust_rounded,
    role => Icons.work_rounded,
    assignee => Icons.accessibility_rounded,
    notes => Icons.comment_rounded,
  };
}

/// useless icons, just for fun :P
const List<IconData> Unicons = [
  Icons.outlined_flag_rounded,
  Icons.auto_awesome_outlined,
  Icons.pets_rounded,
  Icons.flutter_dash_rounded,
  Icons.catching_pokemon_rounded,
  Icons.local_pizza_rounded,
  Icons.cake_rounded,
  Icons.rocket_launch_rounded,
  Icons.golf_course_rounded,
  Icons.bolt_rounded,
  Icons.whatshot_rounded,
  Icons.emoji_events_outlined,
  Icons.diamond_outlined,
];

/// random useless icon, just for fun :P
IconData unicon() => Unicons[Random().nextInt(Unicons.length)];
