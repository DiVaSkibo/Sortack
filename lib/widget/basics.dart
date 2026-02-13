import 'package:sortack/_tools.dart';

/// ground widget - filled page background
class Ground extends StatelessWidget {
  final Widget child;

  const Ground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: Decorations.GROUND_BOX,
      child: child,
    );
  }
}

/// accept dialog widget - dialog for accept action
class AcceptDialog extends StatelessWidget {
  final String? message;
  final Function()? onCancel;
  final Function()? onAccept;
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

/// filter dialog widget - dialog for tasks filtering by parameter
class FilterDialog extends StatelessWidget {
  final List values;
  dynamic from;
  dynamic to;
  final Function()? onCancel;
  final Function(dynamic, dynamic)? onAccept;
  final IconData? icon;
  late Widget fromField;
  late Widget toField;

  FilterDialog({
    super.key,
    required this.values,
    this.from,
    this.to,
    this.onCancel,
    this.onAccept,
    this.icon,
  }) {
    fromField = DropdownButtonFormField(
      items: List<DropdownMenuItem>.generate(
        values.length,
        (index) => DropdownMenuItem(
          value: values[index],
          child: Text(values[index].label),
        ),
      ),
      initialValue: from,
      onChanged: (value) {
        from = value;
      },
      decoration: InputDecoration(labelText: 'from'),
    );
    toField = DropdownButtonFormField(
      items: List<DropdownMenuItem>.generate(
        values.length,
        (index) => DropdownMenuItem(
          value: values[index],
          child: Text(values[index].label),
        ),
      ),
      initialValue: to,
      onChanged: (value) {
        to = value;
      },
    );
  }

  FilterDialog.numbers({
    super.key,
    this.from,
    this.to,
    this.onCancel,
    this.onAccept,
    this.icon,
  }) : values = [] {
    fromField = TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      controller: TextEditingController(text: from),
      onChanged: (value) {
        from = value;
      },
      decoration: InputDecoration(labelText: 'from'),
    );
    toField = TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      controller: TextEditingController(text: to),
      onChanged: (value) {
        to = value;
      },
      decoration: InputDecoration(labelText: 'from'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon != null ? Icon(icon, size: 40) : null,
      content: SizedBox(
        width: 450,
        child: Wrap(
          spacing: 25,
          runSpacing: 25,
          children: [fromField, Text('< x <'), toField],
        ),
      ),
      actions: [
        IconButton(onPressed: onCancel, icon: Icon(Icons.close_rounded)),
        IconButton(
          onPressed: () => from != null && to != null
              ? onAccept!(from, to)
              : debugPrint('\n! INTERVAL VALUES ARE NULLS !\n'),
          icon: Icon(Icons.check_rounded),
        ),
      ],
    );
  }
}
