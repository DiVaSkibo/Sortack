import 'package:sortack/_tools.dart';
import 'package:sortack/logic/task/task_blocks.dart';

/// switch drawers controller - control drawers value changes
class SwitchDrawersController extends ValueNotifier<Drawers> {
  SwitchDrawersController() : super(Drawers.help);

  void show(BuildContext context, Drawers drawer) {
    value = drawer;
    Scaffold.of(context).openEndDrawer();
  }
}

/// task block controller - control task block parameters
class TaskBlockController extends ChangeNotifier {
  final TaskBlock _task;
  TaskBlock get task => _task;

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController notesController;
  final FocusNode titleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode notesFocus = FocusNode();

  TaskBlockController(this._task) {
    _initializeControllers();
    _setupFocusListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    titleFocus.dispose();
    descriptionFocus.dispose();
    notesFocus.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    titleController = TextEditingController(text: _task.title);
    descriptionController = TextEditingController(text: _task.description);
    notesController = TextEditingController(text: _task.notes);
  }

  void _setupFocusListeners() {
    titleFocus.addListener(() {
      if (!titleFocus.hasFocus && titleController.text != _task.title) {
        _task.title = titleController.text;
        notifyListeners();
      }
    });
    descriptionFocus.addListener(() {
      if (!descriptionFocus.hasFocus &&
          descriptionController.text != _task.description) {
        _task.description = descriptionController.text;
        notifyListeners();
      }
    });
    notesFocus.addListener(() {
      if (!notesFocus.hasFocus && notesController.text != _task.notes) {
        _task.notes = notesController.text;
        notifyListeners();
      }
    });
  }

  void updateStatus(TaskStatus status) {
    if (_task.status == status) return;
    _task.status = status;
    notifyListeners();
  }

  void updatePriority(TaskPriority priority) {
    if (_task.priority == priority) return;
    _task.priority = priority;
    notifyListeners();
  }

  void updatePoints(TaskPointsTShirt points) {
    if (_task.points == points) return;
    _task.points = points;
    notifyListeners();
  }
}
