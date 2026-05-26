import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/basics.dart';

/// gradrawer - drawer with gradient
class Gradrawer extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;

  const Gradrawer({
    super.key,
    this.width = 300.0,
    this.height = 550.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Surface(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      width: width,
      height: height,
      child: Drawer(child: child),
    );
  }
}

/// help drawer widget - drawer for help
class HelpDrawer extends StatelessWidget {
  final String label;
  final String asset;

  const HelpDrawer({super.key, required this.label, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Gradrawer(
      width: 550.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 30,
        children: [
          Text(label, style: Styles.TEXT),
          Image.asset(asset),
        ],
      ),
    );
  }
}

/// filter drawer widget - drawer for tasks filtering by parameter
class TaskFilterDrawer extends StatefulWidget {
  final FilterCriteria<TaskParameter>? initialFilter;
  final List<TaskParameter> parameters;
  final List<UserProfile>? assignee;
  final Function(FilterCriteria<TaskParameter>) onChanged;

  const TaskFilterDrawer({
    super.key,
    this.initialFilter,
    required this.parameters,
    this.assignee,
    required this.onChanged,
  });

  @override
  State<TaskFilterDrawer> createState() => _TaskFilterDrawerState();
}

class _TaskFilterDrawerState extends State<TaskFilterDrawer> {
  late final parameters = widget.parameters;
  late final assignee = widget.assignee ?? [];
  late final filter = widget.initialFilter ?? FilterCriteria<TaskParameter>();

  Widget _buildFilter({String? label, required List<ChoiceChip> chips}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 13,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 23,
              children: [
                if (label != null && label.isNotEmpty)
                  Text(label, style: Styles.TEXT),
                IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    size: 16.0,
                    color: Colours.BAD,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: chips,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Gradrawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 30,
        children: [
          for (final parameter in parameters)
            _buildFilter(
              label: parameter.label,
              chips: switch (parameter) {
                TaskParameter.assignee => assignee.map(
                  (value) => ChoiceChip(
                    selected: filter.selected(parameter, value.id),
                    label: Text(value.name),
                    onSelected: (selected) {
                      setState(() {
                        filter.update(parameter, value.id, selected);
                        widget.onChanged(filter);
                      });
                    },
                  ),
                ),
                _ => parameter.parameterValues.map(
                  (value) => ChoiceChip(
                    selected: filter.selected(parameter, value),
                    label: Text(value.label),
                    onSelected: (selected) {
                      setState(() {
                        filter.update(parameter, value, selected);
                        widget.onChanged(filter);
                      });
                    },
                  ),
                ),
              }.toList(),
            ),
        ],
      ),
    );
  }
}
