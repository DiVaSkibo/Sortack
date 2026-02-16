import 'package:sortack/_tools.dart';
import 'package:sortack/logic/opjects.dart';

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

/// filter dialog widget - dialog for tasks filtering by parameter
class TaskFilterDialog extends StatefulWidget {
  final FilterCriteria<TaskParameters>? initialFilter;
  final Function() onCancel;
  final Function(FilterCriteria<TaskParameters>) onAccept;

  const TaskFilterDialog({
    super.key,
    this.initialFilter,
    required this.onCancel,
    required this.onAccept,
  });

  @override
  State<TaskFilterDialog> createState() => _TaskFilterDialogState();
}

class _TaskFilterDialogState extends State<TaskFilterDialog> {
  late final filter = widget.initialFilter ?? FilterCriteria<TaskParameters>();
  //   fromField = TextField(
  //     keyboardType: TextInputType.numberWithOptions(decimal: true),
  //     controller: TextEditingController(text: from),
  //     onChanged: (value) {
  //       from = value;
  //     },
  //     decoration: InputDecoration(labelText: 'from'),
  //   );
  //   toField = TextField(
  //     keyboardType: TextInputType.numberWithOptions(decimal: true),
  //     controller: TextEditingController(text: to),
  //     onChanged: (value) {
  //       to = value;
  //     },
  //     decoration: InputDecoration(labelText: 'from'),
  //   );

  SizedBox _buildPriorityFilter() => SizedBox(
    child: Wrap(
      children: TaskPriority.values
          .map(
            (value) => FilterChip(
              selected: filter.selected(TaskParameters.priority, value),
              label: Text(value.label),
              onSelected: (selected) {
                setState(() {
                  filter.update(TaskParameters.priority, value, selected);
                });
              },
            ),
          )
          .toList(),
    ),
  );
  SizedBox _buildPointsFilter() => SizedBox(
    child: Wrap(
      children: TaskPointsTShirt.values
          .map(
            (value) => FilterChip(
              selected: filter.selected(TaskParameters.points, value),
              label: Text(value.label),
              onSelected: (selected) {
                setState(() {
                  filter.update(TaskParameters.points, value, selected);
                });
              },
            ),
          )
          .toList(),
    ),
  );
  SizedBox _buildRolesFilter() => SizedBox(
    child: Wrap(
      children: TaskRoles.values
          .map(
            (value) => FilterChip(
              selected: filter.selected(TaskParameters.role, value),
              label: Text(value.label),
              onSelected: (selected) {
                setState(() {
                  filter.update(TaskParameters.role, value, selected);
                });
              },
            ),
          )
          .toList(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.filter_list_rounded, size: 40),
      content: SizedBox(
        width: 450,
        child: Wrap(
          spacing: 25,
          runSpacing: 25,
          children: [
            _buildPriorityFilter(),
            _buildPointsFilter(),
            _buildRolesFilter(),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: widget.onCancel, icon: Icon(Icons.close_rounded)),
        IconButton(
          onPressed: () => widget.onAccept(filter),
          icon: Icon(Icons.check_rounded),
        ),
      ],
    );
  }
}
