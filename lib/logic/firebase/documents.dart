import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/logic/_tasks.dart';

typedef Document = Map<String, dynamic>;

Document blockToDoc(Block block, String plankId, int order) =>
    <String, dynamic>{
      'plankId': plankId,
      'title': block.title,
      'description': block.description,
      'points': block.points?.name,
      'deadline': block.deadline,
      'assignee': block.assignee,
      if (block is AdvancedBlock) 'status': block.status.name,
      if (block is AdvancedBlock) 'priority': block.priority.name,
      if (block is AdvancedBlock) 'tags': block.tags,
      if (block is AdvancedBlock) 'notes': block.notes,
      'order': order,
    };
Document plankToDoc(Plank plank, int order, {String? key}) => <String, dynamic>{
  'title': plank.title,
  'color': plank.color.toHex(),
  'order': order,
  'key': ?key,
};
Document detailsToDoc(DeckDetails deck) => <String, dynamic>{
  'name': deck.name.trim(),
  'description': deck.description,
  'methodology': deck.methodology.name,
};

Block docToBlock<T extends Block>(Document doc, String id) => switch (T) {
  const (AdvancedBlock) => AdvancedBlock(
    id: id,
    title: doc['title'] ?? '',
    description: doc['description'] ?? '',
    deadline: doc['deadline'] != null
        ? (doc['deadline'] as Timestamp).toDate()
        : DateTime.now().add(Duration(days: 1)),
    status: TaskStatus.values.asNameMap()[doc['status']] ?? TaskStatus.toDo,
    priority:
        TaskPriority.values.asNameMap()[doc['priority']] ?? TaskPriority.medium,
    points: doc['points'] != null
        ? TaskPointsTShirt.values.asNameMap()[doc['points']]
        : null,
    assignee: List<String>.from(doc['assignee'] ?? []),
    tags: List<String>.from(doc['tags'] ?? []),
    notes: doc['notes'] ?? '',
  ),
  _ => Block(
    id: id,
    title: doc['title'] ?? '',
    description: doc['description'] ?? '',
    deadline: doc['deadline'] != null
        ? (doc['deadline'] as Timestamp).toDate()
        : DateTime.now(),
    points: doc['points'] != null
        ? TaskPointsTShirt.values.asNameMap()[doc['points']]
        : null,
    assignee: List<String>.from(doc['assignee'] ?? []),
  ),
};
Plank docToPlank<T extends Plank>(Document doc, String id) => switch (T) {
  const (AdvancedPlank) => AdvancedPlank(
    id: id,
    title: doc['title'] ?? '',
    color: doc['color'] != null
        ? ColorExtension.fromHex(doc['color'])
        : Colours.W,
    blocks: [],
  ),
  _ => Plank(
    id: id,
    title: doc['title'] ?? '',
    color: doc['color'] != null
        ? ColorExtension.fromHex(doc['color'])
        : Colours.W,
    blocks: [],
  ),
};
