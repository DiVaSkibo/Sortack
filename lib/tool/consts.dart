import 'dart:math';
import 'package:sortack/tool/abstracts.dart';
import 'package:sortack/tool/style.dart';

/// task status enum - task statuses
///
/// [to do, in progress, done]
enum TaskStatus with ComparableEnum<TaskStatus> {
  toDo,
  inProgress,
  done;

  Color colour() => switch (this) {
    toDo => Colours.NOTOK,
    inProgress => Colours.INOK,
    done => Colours.OK,
  };
}

/// task priority enum - task priority levels
///
/// [critical, very high, high, medium, low, very low]
enum TaskPriority with ComparableEnum<TaskPriority> {
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
}

/// task fibonacci points enum - task points using fibonacci system
///
/// [0, 1, 2, 3, 5, 8, 13, 20, 40, 100]
enum TaskPointsFibonacci with TaskPointing {
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

  const TaskPointsFibonacci(this._value);
}

/// task tshirt points enum - task points using tshirt system
///
/// [XS, S, M, L, XL, XXL]
enum TaskPointsTShirt with TaskPointing {
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
}

/// task roles enum - task roles
///
/// [XS, S, M, L, XL, XXL]
enum TaskRoles with ComparableEnum { Design, Development, QA }

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
    points => TaskPointsTShirt,
    role => String,
    assignee => String,
    notes => String,
  };
  @override
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
