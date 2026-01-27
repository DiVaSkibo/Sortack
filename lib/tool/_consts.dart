import 'dart:math';
export 'dart:math';
import 'package:sortack/tool/_style.dart';
export 'package:sortack/tool/_style.dart';

/// status enum - task status
///
/// [to do, in progress, done]
enum Status implements Comparable<Status> {
  toDo,
  inProgress,
  done;

  Color colour() => switch (this) {
    toDo => Colours.NOTOK,
    inProgress => Colours.INOK,
    done => Colours.OK,
  };

  @override
  int compareTo(Status other) => index - other.index;
}

/// priority level enum - task priority
///
/// [critical, very high, high, medium, low, very low]
enum PriorityLevel implements Comparable<PriorityLevel> {
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
  int compareTo(PriorityLevel other) => index - other.index;
}

/// fibonacci points enum - task points using fibonacci system
///
/// [0, 1, 2, 3, 5, 8, 13, 20, 40, 100]
enum PointsFibonacci implements Comparable<PointsFibonacci> {
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
  int compareTo(PointsFibonacci other) => index - other.index;
}

/// tshirt points enum - task points using tshirt system
///
/// [XS, S, M, L, XL, XXL]
enum PointsTShirt implements Comparable<PointsTShirt> {
  XS,
  S,
  M,
  L,
  XL,
  XXL;

  @override
  int compareTo(PointsTShirt other) => index - other.index;
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
    status => Status,
    priority => PriorityLevel,
    points => PointsTShirt,
    role => String,
    assignee => String,
    notes => String,
  };

  List parameterValues() => switch (this) {
    TaskParameters.id => [],
    TaskParameters.title => [],
    TaskParameters.description => [],
    TaskParameters.status => Status.values,
    TaskParameters.priority => PriorityLevel.values,
    TaskParameters.points => PointsTShirt.values,
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
