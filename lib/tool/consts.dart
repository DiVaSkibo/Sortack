import 'dart:math';
import 'package:sortack/tool/abstracts.dart';
import 'package:sortack/tool/style.dart';

/// task status enum - task statuses
///
/// [to do, in progress, done]
enum TaskStatus with Labeling, ComparableEnum<TaskStatus> {
  toDo,
  inProgress,
  done;

  @override
  String get label => switch (this) {
    toDo => 'To Do',
    inProgress => 'In Progress',
    done => 'Done',
  };

  Color colour() => switch (this) {
    toDo => Colours.NOTOK,
    inProgress => Colours.INOK,
    done => Colours.OK,
  };
}

/// task priority enum - task priority levels
///
/// [critical, very high, high, medium, low, very low]
enum TaskPriority with Labeling, ComparableEnum<TaskPriority> {
  critical,
  very_high,
  high,
  medium,
  low,
  very_low;

  @override
  String get label => switch (this) {
    critical => 'critical',
    very_high => 'very high',
    high => 'high',
    medium => 'medium',
    low => 'low',
    very_low => 'very low',
  };

  Color colour() => switch (this) {
    critical => Colours.NOTOK,
    very_high => Colours.NOTOK,
    high => Colours.NOTOK,
    medium => Colours.INOK,
    low => Colours.OK,
    very_low => Colours.BOTTOM,
  };
}

/// task fibonacci points enum - task points using fibonacci system
///
/// [0, 1, 2, 3, 5, 8, 13, 20, 40, 100]
enum TaskPointsFibonacci with Labeling, TaskPointing {
  X0(0),
  X1(1),
  X2(2),
  X3(3),
  X5(5),
  X8(8),
  X13(13),
  X20(20),
  X40(40),
  X100(100);

  final int _value;

  @override
  int get value => _value;
  @override
  String get label => _value.toString();

  const TaskPointsFibonacci(this._value);
}

/// task tshirt points enum - task points using tshirt system
///
/// [XS, S, M, L, XL, XXL]
enum TaskPointsTShirt with Labeling, TaskPointing {
  XS,
  S,
  M,
  L,
  XL,
  XXL;

  @override
  int get value => switch (this) {
    XS => 0,
    S => 2,
    M => 8,
    L => 13,
    XL => 20,
    XXL => 40,
  };
  @override
  String get label => name;
}

/// task roles enum - task roles
///
/// [Design, Development, QA]
enum TaskRoles with Labeling, ComparableEnum<TaskRoles> {
  Design,
  Development,
  QA;

  @override
  String get label => name;
}

/// task parameters enum - parameters of a task class
///
/// [id, title, description, status, priority, points, role, assignee, notes]
enum TaskParameters implements Parameters {
  id,
  title,
  description,
  status,
  priority,
  points,
  role,
  assignee,
  notes;

  @override
  Type type() => switch (this) {
    id => int,
    title => String,
    description => String,
    status => TaskStatus,
    priority => TaskPriority,
    points => TaskPointing,
    role => String,
    assignee => String,
    notes => String,
  };
  @override
  List parameterValues() => switch (this) {
    id => [],
    title => [],
    description => [],
    status => TaskStatus.values,
    priority => TaskPriority.values,
    points => TaskPointsTShirt.values,
    role => [],
    assignee => [],
    notes => [],
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

/// drawers enum
///
/// [help, info, control, filter]
enum Drawers { help, info, control, filter }

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
