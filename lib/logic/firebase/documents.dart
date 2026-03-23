import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/logic/task/blocks.dart';
import 'package:sortack/logic/task/planks.dart';
import 'package:sortack/logic/task/decks.dart';

typedef Document = Map<String, dynamic>;

Document blockToDoc(Block block, String plankId, int order) =>
    <String, dynamic>{
      'plankId': plankId,
      'title': block.title,
      'description': block.description,
      'priority': block.priority?.name,
      'deadline': block.deadline,
      'assignee': block.assignee,
      if (block is AdvancedBlock) 'status': block.status.name,
      if (block is AdvancedBlock) 'points': block.points?.name,
      if (block is AdvancedBlock) 'role': block.role,
      if (block is AdvancedBlock) 'notes': block.notes,
      'order': order,
    };
Document plankToDoc(Plank plank, int order) => <String, dynamic>{
  'title': plank.title,
  'color': plank.color.toHex(),
  'order': order,
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
        : DateTime.now(),
    status: TaskStatus.values.asNameMap()[doc['status']] ?? TaskStatus.toDo,
    priority: doc['priority'] != null
        ? TaskPriority.values.asNameMap()[doc['priority']]
        : null,
    points: doc['points'] != null
        ? TaskPointsTShirt.values.asNameMap()[doc['points']]
        : null,
    role: doc['role'],
    assignee: doc['assignee'],
    notes: doc['notes'] ?? '',
  ),
  _ => Block(
    id: id,
    title: doc['title'] ?? '',
    description: doc['description'] ?? '',
    deadline: doc['deadline'] != null
        ? (doc['deadline'] as Timestamp).toDate()
        : DateTime.now(),
    priority: doc['priority'] != null
        ? TaskPriority.values.asNameMap()[doc['priority']]
        : null,
    assignee: doc['assignee'],
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
