import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/basics.dart';

/// help drawer widget - drawer for help
class HelpDrawer extends StatelessWidget {
  const HelpDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 1,
                  colors: [Colours.BACK, Colours.UNFRONT],
                ),
              ),
              padding: EdgeInsetsGeometry.all(0),
              child: Icon(Icons.blur_on_rounded, size: 75),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Explore'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.fort_rounded),
              label: const Text('Fort'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.format_paint_rounded),
              label: const Text('Format paint'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.airplane_ticket_rounded),
              label: const Text('Airplane ticket'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.church_rounded),
              label: const Text('Church'),
            ),
          ],
        ),
      ),
    );
  }
}

/// filter drawer widget - drawer for tasks filtering by parameter
class TaskFilterDrawer extends StatefulWidget {
  final FilterCriteria<TaskParameters>? initialFilter;
  final Function(FilterCriteria<TaskParameters>) onChanged;

  const TaskFilterDrawer({
    super.key,
    this.initialFilter,
    required this.onChanged,
  });

  @override
  State<TaskFilterDrawer> createState() => _TaskFilterDrawerState();
}

class _TaskFilterDrawerState extends State<TaskFilterDrawer> {
  late final filter = widget.initialFilter ?? FilterCriteria<TaskParameters>();

  SizedBox _buildPrioritiesFilter() => SizedBox(
    child: Center(
      child: Column(
        spacing: 12.5,
        children: [
          Text('Priorities:'),
          Wrap(
            spacing: 11.0,
            runSpacing: 9.0,
            children: Priority.values
                .map(
                  (value) => ChoiceChip(
                    selected: filter.selected(TaskParameters.priority, value),
                    label: Text(value.label),
                    onSelected: (selected) {
                      setState(() {
                        filter.update(TaskParameters.priority, value, selected);
                        widget.onChanged(filter);
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );
  SizedBox _buildPointsFilter() => SizedBox(
    child: Center(
      child: Column(
        spacing: 12.5,
        children: [
          Text('Points:'),
          Wrap(
            spacing: 11.0,
            runSpacing: 9.0,
            children: PointsTShirt.values
                .map(
                  (value) => ChoiceChip(
                    selected: filter.selected(TaskParameters.points, value),
                    label: Text(value.label),
                    onSelected: (selected) {
                      setState(() {
                        filter.update(TaskParameters.points, value, selected);
                        widget.onChanged(filter);
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );
  SizedBox _buildRolesFilter() => SizedBox(
    child: Center(
      child: Column(
        spacing: 12.5,
        children: [
          Text('Roles:'),
          Wrap(
            spacing: 11.0,
            runSpacing: 9.0,
            children: Tag.values
                .map(
                  (value) => ChoiceChip(
                    selected: filter.selected(TaskParameters.role, value),
                    label: Text(value.label),
                    onSelected: (selected) {
                      setState(() {
                        filter.update(TaskParameters.role, value, selected);
                        widget.onChanged(filter);
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Surface(
      child: Drawer(
        child: Column(
          spacing: 25,
          children: [
            _buildPrioritiesFilter(),
            _buildPointsFilter(),
            _buildRolesFilter(),
          ],
        ),
      ),
    );
  }
}
