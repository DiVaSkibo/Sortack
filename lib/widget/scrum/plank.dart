import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';
import 'package:sortack/widget/dialogs.dart';
import 'package:sortack/widget/scrum/block.dart';

/// Scrum table class - task plank view with Scrum row children
class ScrumTable extends StatefulWidget {
  final String deckId;
  final Plank<AdvancedBlock> tasks;
  final int order;
  final Map<String, UserProfile>? members;
  final List<Iction>? ictions;
  final bool constant;
  final VoidCallback? onDelete;

  ScrumTable({
    Key? key,
    required this.deckId,
    required this.tasks,
    required this.order,
    this.members,
    this.ictions,
    this.constant = false,
    this.onDelete,
  }) : super(key: key ?? ObjectKey(tasks));

  @override
  State<ScrumTable> createState() => _ScrumTableState();
}

class _ScrumTableState extends State<ScrumTable> {
  late final Plank<AdvancedBlock> tasks = widget.tasks;
  late final int order = widget.order;

  late final TextEditingController _titleController;
  late final FocusNode _titleFocus = FocusNode();
  final ScrollController _horizontalController = ScrollController();

  List<AdvancedBlock> get visibleTasks => tasks.visibleBlocks;

  Color get colourAc => switch (tasks.color) {
    Colours.ANCHOR => Colours.ANCHOR_AC,
    Colours.DRIVE => Colours.DRIVE_AC,
    Colours.SHIFT => Colours.SHIFT_AC,
    _ => Colours.F.withAlpha(50),
  };

  @override
  void initState() {
    super.initState();
    // title
    _titleController = TextEditingController(text: tasks.title);
    _titleFocus.addListener(() async {
      if (!_titleFocus.hasFocus && _titleController.text != tasks.title) {
        tasks.title = _titleController.text;
        update();
      }
    });
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _titleController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  void update() async {
    // fire
    try {
      await FireRources.savePlank(widget.deckId, tasks, widget.order);
    } catch (exc) {
      debugPrint('? ERROR: on saving row changes; $exc');
    }
  }

  void clean() async {
    var tasksIds = tasks.blocks.map((block) => block.id).toList();
    // display
    setState(() {
      tasks.clear();
    });
    // fire
    for (final taskId in tasksIds) {
      await FireRources.deleteBlock(widget.deckId, taskId);
    }
  }

  void delete() async {
    // delete tasks inside
    for (final task in tasks.blocks)
      await FireRources.deleteBlock(widget.deckId, task.id);
    // display
    widget.onDelete?.call();
    // fire
    await FireRources.deletePlank(widget.deckId, tasks.id);
  }

  Widget _buildTitle() => TextField(
    controller: _titleController,
    focusNode: _titleFocus,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 20,
      fontFamily: Fonts.RUBIK,
      fontWeight: FontWeight.w900,
      color: Colours.CANVAS,
    ),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(15.0),
      filled: true,
      fillColor: Colours.a,
      hoverColor: colourAc,
    ),
    onEditingComplete: () {
      _titleFocus.unfocus();
    },
    onTapOutside: (event) {
      _titleFocus.unfocus();
    },
  );
  Widget _buildColour(BuildContext context) => IconButton(
    icon: const Icon(Icons.colorize_rounded, size: 16, color: Colours.INK),
    onPressed: () async {
      final selected = await showDialog<Color>(
        context: context,
        builder: (context) => ColourGradialog(),
      );
      if (selected != null) {
        setState(() {
          tasks.color = selected;
        });
        update();
      }
    },
  );
  Widget _buildColumn(String text, {int flex = 1}) => Expanded(
    flex: flex,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontFamily: Fonts.RUBIK_ONE,
          color: Colours.CANVAS_AC,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 15.0),
      initiallyExpanded: true,
      maintainState: true,
      collapsedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(26)),
        side: BorderSide.none,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        side: BorderSide.none,
      ),
      collapsedBackgroundColor: tasks.color.withAlpha(175),
      backgroundColor: tasks.color,
      collapsedIconColor: Colours.INK_AC,
      iconColor: Colours.INK,
      collapsedTextColor: Colours.CANVAS,
      textColor: Colours.CANVAS,
      leading: _buildColour(context),
      title: _buildTitle(),
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        runSpacing: 6,
        children: [
          if (widget.ictions != null && widget.ictions!.isNotEmpty)
            for (final iction in widget.ictions!)
              IconButton(
                icon: Icon(
                  iction.icon,
                  size: 18,
                  color: Colours.SHIFT,
                  shadows: List.generate(
                    20,
                    (index) => const Shadow(blurRadius: 0.75, color: Colours.O),
                  ),
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AcceptGradialog(
                    message: 'Do you realy want to clean this table?...',
                    onAccept: () => iction.call(),
                    icon: Icons.playlist_remove_rounded,
                  ),
                ),
              ),
          if (widget.constant)
            IconButton(
              icon: Icon(
                Icons.playlist_remove_rounded,
                size: 18,
                color: Colours.DRIVE_AC,
                shadows: List.generate(
                  20,
                  (index) => const Shadow(blurRadius: 0.75, color: Colours.O),
                ),
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AcceptGradialog(
                  message: 'Do you realy want to clean this table?...',
                  onAccept: () => clean(),
                  icon: Icons.playlist_remove_rounded,
                ),
              ),
            ),
          if (widget.onDelete != null)
            IconButton(
              icon: Icon(
                Icons.delete_forever_rounded,
                size: 18,
                color: Colours.DRIVE_AC,
                shadows: List.generate(
                  20,
                  (index) => const Shadow(blurRadius: 0.75, color: Colours.O),
                ),
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AcceptGradialog(
                  message: 'Do you realy want to delete this table?...',
                  onAccept: () => delete(),
                  icon: Icons.remove_rounded,
                ),
              ),
            ),
        ],
      ),
      subtitle: const SizedBox(height: 10.0),
      children: [
        LayoutBuilder(
          builder: (context, constraints) => Scrollbar(
            controller: _horizontalController,
            scrollbarOrientation: ScrollbarOrientation.top,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: Container(
                width: constraints.maxWidth > 1200.0
                    ? constraints.maxWidth
                    : 1200.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    strokeAlign: BorderSide.strokeAlignCenter,
                    width: 3,
                    color: tasks.color,
                  ),
                ),
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  itemCount: visibleTasks.length,
                  header: Container(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 11.0),
                    color: tasks.color,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildColumn('#'),
                        _buildColumn('Title', flex: 3),
                        _buildColumn('Description', flex: 4),
                        _buildColumn('Deadline', flex: 2),
                        _buildColumn('Status', flex: 2),
                        _buildColumn('Priority', flex: 2),
                        _buildColumn('Points', flex: 2),
                        _buildColumn('Assignee', flex: 2),
                        _buildColumn('Tags', flex: 2),
                        _buildColumn('Notes', flex: 3),
                      ],
                    ),
                  ),
                  itemBuilder: (context, index) => ScrumRow(
                    deckId: widget.deckId,
                    plankId: tasks.id,
                    task: visibleTasks[index],
                    order: index,
                    members: widget.members,
                    onDelete: () {
                      setState(() {
                        tasks.pop(visibleTasks[index]);
                      });
                    },
                  ),
                  onReorder: (oldIndex, newIndex) async {
                    if (newIndex > oldIndex) newIndex -= 1;
                    setState(() {
                      tasks.move(oldIndex, newIndex);
                    });
                    await FireRources.updateBlocksOrder(widget.deckId, tasks);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
