import 'package:sortack/_tools.dart';
//import 'package:sortack/_logics.dart';

/// ground widget - filled page background
class Ground extends StatelessWidget {
  final Widget child;

  const Ground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: Decorations.DECK_BOX,
      child: child,
    );
  }
}

/// surface widget - filled dialog background
class Surface extends StatelessWidget {
  final Widget child;

  const Surface({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      //height: double.infinity,
      decoration: Decorations.SURFACE_BOX,
      child: child,
    );
  }
}

/// accept dialog widget - dialog for accept action
class AcceptDialog extends StatelessWidget {
  final String? message;
  final Function() onCancel;
  final Function() onAccept;
  final IconData? icon;

  const AcceptDialog({
    super.key,
    this.message,
    required this.onCancel,
    required this.onAccept,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon != null ? Icon(icon, size: 40) : null,
      content: Text(message ?? 'are you sure?...'),
      actions: [
        IconButton(onPressed: onCancel, icon: Icon(Icons.close_rounded)),
        IconButton(onPressed: onAccept, icon: Icon(Icons.check_rounded)),
      ],
    );
  }
}
