import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/_tasks.dart';

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
    emailFocus.dispose();
    passwordFocus.dispose();
    emailController.dispose();
    passwordController.dispose();
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

/// block controller
class BlockController extends ChangeNotifier {
  final Block _task;
  Block get task => _task;

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  final FocusNode titleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final Function()? onUnfocus;

  BlockController(this._task, {this.onUnfocus}) {
    _initializeControllers();
    _setupFocusListeners();
  }

  @override
  void dispose() {
    titleFocus.dispose();
    descriptionFocus.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    titleController = TextEditingController(text: _task.title);
    descriptionController = TextEditingController(text: _task.description);
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
  }

  void updateDeadline(DateTime deadline) {
    if (_task.deadline == deadline) return;
    _task.deadline = deadline;
    onUnfocus?.call();
    notifyListeners();
  }

  void updatePoints(PointsTShirt points) {
    if (_task.points == points) return;
    _task.points = points;
    onUnfocus?.call();
    notifyListeners();
  }

  void updateAssignee(Set<String> assignee) {
    if (_task.assignee == assignee) return;
    _task.assignee = assignee;
    onUnfocus?.call();
    notifyListeners();
  }
}

/// advanced block controller
class AdvancedBlockController extends ChangeNotifier {
  final AdvancedBlock _task;
  AdvancedBlock get task => _task;

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController notesController;
  final FocusNode titleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode notesFocus = FocusNode();
  final Function()? onUnfocus;

  AdvancedBlockController(this._task, {this.onUnfocus}) {
    _initializeControllers();
    _setupFocusListeners();
  }

  @override
  void dispose() {
    titleFocus.dispose();
    descriptionFocus.dispose();
    notesFocus.dispose();
    titleController.dispose();
    descriptionController.dispose();
    notesController.dispose();
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

  void updateDeadline(DateTime deadline) {
    if (_task.deadline == deadline) return;
    _task.deadline = deadline;
    onUnfocus?.call();
    notifyListeners();
  }

  void updateStatus(Status status) {
    if (_task.status == status) return;
    _task.status = status;
    onUnfocus?.call();
    notifyListeners();
  }

  void updatePriority(Priority priority) {
    if (_task.priority == priority) return;
    _task.priority = priority;
    onUnfocus?.call();
    notifyListeners();
  }

  void updatePoints(PointsTShirt points) {
    if (_task.points == points) return;
    _task.points = points;
    onUnfocus?.call();
    notifyListeners();
  }

  void updateAssignee(Set<String> assignee) {
    if (_task.assignee == assignee) return;
    _task.assignee = assignee;
    onUnfocus?.call();
    notifyListeners();
  }

  void updateTags(Set<Tag> tags) {
    if (_task.tags == tags) return;
    _task.tags = tags;
    onUnfocus?.call();
    notifyListeners();
  }
}

/// project details controller
class ProjectDetailsController extends ChangeNotifier {
  final ProjectDetails _project;
  ProjectDetails get project => _project;

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController ownerController;
  final FocusNode nameFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode ownerFocus = FocusNode();
  final Function()? onUnfocus;

  ProjectDetailsController(this._project, {this.onUnfocus}) {
    _initializeControllers();
    _setupFocusListeners();
  }

  @override
  void dispose() {
    nameFocus.dispose();
    descriptionFocus.dispose();
    ownerFocus.dispose();
    nameController.dispose();
    descriptionController.dispose();
    ownerController.dispose();
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
        onUnfocus?.call();
        notifyListeners();
      }
    });
    descriptionFocus.addListener(() {
      if (!descriptionFocus.hasFocus &&
          descriptionController.text != _project.description) {
        _project.description = descriptionController.text;
        onUnfocus?.call();
        notifyListeners();
      }
    });
    ownerFocus.addListener(() {
      if (!ownerFocus.hasFocus && ownerController.text != _project.owner) {
        _project.owner = ownerController.text;
        onUnfocus?.call();
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

/// switch drawers controller
class SwitchDrawersController extends ValueNotifier<Drawers> {
  SwitchDrawersController() : super(Drawers.help);

  void show(BuildContext context, Drawers drawer) {
    value = drawer;
    Scaffold.of(context).openEndDrawer();
  }
}
