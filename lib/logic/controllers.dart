import 'package:sortack/_tools.dart';
import 'package:sortack/logic/task/blocks.dart';
import 'package:sortack/logic/task/decks.dart';

/// auth controller - control email and password
class AuthController extends ChangeNotifier {
  String _email;
  String _password;

  String get email => _email;
  String get password => _password;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  AuthController({String? email, String? password})
    : _email = email ?? '',
      _password = password ?? '' {
    _initializeControllers();
    _setupFocusListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    emailController = TextEditingController(text: _email);
    passwordController = TextEditingController(text: _password);
  }

  void _setupFocusListeners() {
    emailFocus.addListener(() {
      if (!emailFocus.hasFocus && emailController.text != _email) {
        _email = emailController.text;
        notifyListeners();
      }
    });
    passwordFocus.addListener(() {
      if (!passwordFocus.hasFocus && passwordController.text != _password) {
        _password = passwordController.text;
        notifyListeners();
      }
    });
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
  final Function()? onUnfocus;

  TaskBlockController(this._task, {this.onUnfocus}) {
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
      if (!titleFocus.hasFocus &&
          titleController.text.isNotEmpty &&
          titleController.text != _task.title) {
        _task.title = titleController.text;
        onUnfocus?.call();
        notifyListeners();
      }
    });
    descriptionFocus.addListener(() {
      if (!descriptionFocus.hasFocus &&
          descriptionController.text.isNotEmpty &&
          descriptionController.text != _task.description) {
        _task.description = descriptionController.text;
        onUnfocus?.call();
        notifyListeners();
      }
    });
    notesFocus.addListener(() {
      if (!notesFocus.hasFocus &&
          notesController.text.isNotEmpty &&
          notesController.text != _task.notes) {
        _task.notes = notesController.text;
        onUnfocus?.call();
        notifyListeners();
      }
    });
  }

  void updateStatus(TaskStatus status) {
    if (_task.status == status) return;
    _task.status = status;
    onUnfocus?.call();
    notifyListeners();
  }

  void updatePriority(TaskPriority priority) {
    if (_task.priority == priority) return;
    _task.priority = priority;
    onUnfocus?.call();
    notifyListeners();
  }

  void updatePoints(TaskPointsTShirt points) {
    if (_task.points == points) return;
    _task.points = points;
    onUnfocus?.call();
    notifyListeners();
  }
}

/// deck details controller - control deck details parameters
class DeckDetailsController extends ChangeNotifier {
  final DeckDetails _project;
  DeckDetails get project => _project;

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController ownerController;
  final FocusNode nameFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode ownerFocus = FocusNode();

  DeckDetailsController(this._project) {
    _initializeControllers();
    _setupFocusListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    ownerController.dispose();
    nameFocus.dispose();
    descriptionFocus.dispose();
    ownerFocus.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    nameController = TextEditingController(text: _project.name);
    descriptionController = TextEditingController(text: _project.description);
    ownerController = TextEditingController(text: _project.owner);
  }

  void _setupFocusListeners() {
    nameFocus.addListener(() {
      if (!nameFocus.hasFocus && nameController.text != _project.name) {
        _project.name = nameController.text;
        notifyListeners();
      }
    });
    descriptionFocus.addListener(() {
      if (!descriptionFocus.hasFocus &&
          descriptionController.text != _project.description) {
        _project.description = descriptionController.text;
        notifyListeners();
      }
    });
    ownerFocus.addListener(() {
      if (!ownerFocus.hasFocus && ownerController.text != _project.owner) {
        _project.owner = ownerController.text;
        notifyListeners();
      }
    });
  }

  void updateMethodology(Methodology methodology) {
    if (_project.methodology == methodology) return;
    _project.methodology = methodology;
    notifyListeners();
  }

  void updateCreated(DateTime created) {
    if (_project.created == created) return;
    _project.created = created;
    notifyListeners();
  }

  void updateMembers(List<String> members) {
    if (_project.members == members) return;
    _project.members = members;
    notifyListeners();
  }
}

/// switch drawers controller - control drawers value changes
class SwitchDrawersController extends ValueNotifier<Drawers> {
  SwitchDrawersController() : super(Drawers.help);

  void show(BuildContext context, Drawers drawer) {
    value = drawer;
    Scaffold.of(context).openEndDrawer();
  }
}
