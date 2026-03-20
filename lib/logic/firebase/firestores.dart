import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/logic/firebase/authentications.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task/blocks.dart';
import 'package:sortack/logic/task/planks.dart';
import 'package:sortack/logic/task/decks.dart';

typedef Doc = Map<String, dynamic>;

/// firestore resources - load, save, update and other resources
final class FireRources {
  // GETs
  /// get doc query of user
  static Query<Doc> getUserDecks(User user) => FirebaseFirestore.instance
      .collection('decks')
      .where('members', arrayContains: user.uid);

  /// get doc collection reference of all decks
  static CollectionReference<Doc> getDecks() =>
      FirebaseFirestore.instance.collection('decks');

  /// get doc collection reference of all planks by id
  static CollectionReference<Doc> getPlanks(String id) =>
      getDecks().doc(id).collection('planks');

  /// get doc collection reference of all blocks by id
  static CollectionReference<Doc> getBlocks(String id) =>
      getDecks().doc(id).collection('blocks');

  // LOADs
  /// load deck details resource by doc
  static DeckDetails loadDeckDetails(DocumentSnapshot doc) {
    final data = doc.data() as Doc;
    return DeckDetails(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      methodology:
          Methodology.values.asNameMap()[data['methodology']] ??
          Methodology.Kanban,
      created: data['created'] != null
          ? (data['created'] as Timestamp).toDate()
          : DateTime.now(),
      owner: data['owner'],
      members: List<String>.from(data['members'] ?? []),
    );
  }

  /// load deck resource by deck id
  static Future<T> loadDeck<T extends TaskDeck>(String deckId) async {
    final deckRef = getDecks().doc(deckId);
    final results = await Future.wait([
      deckRef.get(),
      deckRef.collection('planks').orderBy('order').get(),
      deckRef.collection('blocks').orderBy('order').get(),
    ]);
    final deckDoc = results[0] as DocumentSnapshot;
    final planksSnapshot = results[1] as QuerySnapshot;
    final blocksSnapshot = results[2] as QuerySnapshot;
    if (!deckDoc.exists) throw Exception('? Deck is not found');
    final details = loadDeckDetails(deckDoc);
    final Map<String, TaskPlank> planksMap = {};
    final List<TaskPlank> planksList = [];
    for (var doc in planksSnapshot.docs) {
      final plank = switch (T) {
        const (AdvancedTaskDeck) => loadPlank<AdvancedTaskPlank>(doc),
        _ => loadPlank<TaskPlank>(doc),
      };
      planksMap[doc.id] = plank;
      planksList.add(plank);
    }
    for (var doc in blocksSnapshot.docs) {
      final block = switch (T) {
        const (AdvancedTaskDeck) => loadBlock<AdvancedTaskBlock>(doc),
        _ => loadBlock<TaskBlock>(doc),
      };
      final data = doc.data() as Doc;
      final plankId = data['plankId'] as String?;
      if (plankId != null && planksMap.containsKey(plankId))
        planksMap[plankId]!.blocks.add(block);
      else if (planksList.isNotEmpty)
        planksList.first.blocks.add(block);
    }

    return switch (T) {
      const (AdvancedTaskDeck) =>
        AdvancedTaskDeck(
              details: details,
              planks: planksList as List<AdvancedTaskPlank>,
            )
            as T,
      _ => DetailedTaskDeck(details: details, planks: planksList) as T,
    };
  }

  /// load plank resource by doc
  static TaskPlank loadPlank<T extends TaskPlank>(DocumentSnapshot doc) {
    final data = doc.data() as Doc;
    String title = data['title'] ?? '';
    Color color = data['color'] != null
        ? ColorExtension.fromHex(data['color'])
        : Colours.W;

    return switch (T) {
      const (AdvancedTaskPlank) => AdvancedTaskPlank(
        id: doc.id,
        title: title,
        color: color,
        blocks: [],
      ),
      _ => TaskPlank(id: doc.id, title: title, color: color, blocks: []),
    };
  }

  /// load block resource by doc
  static TaskBlock loadBlock<T extends TaskBlock>(DocumentSnapshot doc) {
    final data = doc.data() as Doc;
    String title = data['title'] ?? '';
    String description = data['description'] ?? '';
    TaskPriority? priority = data['priority'] != null
        ? TaskPriority.values.asNameMap()[data['priority']]
        : null;
    DateTime deadline = data['deadline'] != null
        ? (data['deadline'] as Timestamp).toDate()
        : DateTime.now();
    String? assignee = data['assignee'];

    return switch (T) {
      const (AdvancedTaskBlock) => AdvancedTaskBlock(
        id: doc.id,
        title: title,
        description: description,
        status:
            TaskStatus.values.asNameMap()[data['status']] ?? TaskStatus.toDo,
        priority: priority,
        points: data['points'] != null
            ? TaskPointsTShirt.values.asNameMap()[data['points']]
            : null,
        role: data['role'],
        deadline: deadline,
        assignee: assignee,
        notes: data['notes'] ?? '',
      ),
      _ => TaskBlock(
        id: doc.id,
        title: title,
        description: description,
        priority: priority,
        deadline: deadline,
        assignee: assignee,
      ),
    };
  }

  // SAVEs
  /// save deck details resource
  static Future<void> saveProject(DeckDetails deck) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('? User is not authorised...');
    final isNew = deck.id.isEmpty || deck.id == '#';
    final deckRef = isNew ? getDecks().doc() : getDecks().doc(deck.id);
    final batch = FirebaseFirestore.instance.batch();
    final deckData = <String, dynamic>{
      'name': deck.name.trim(),
      'description': deck.description,
      'methodology': deck.methodology.name,
    };
    if (isNew) {
      deckData['created'] = FieldValue.serverTimestamp();
      deckData['owner'] = currentUser.uid;
      deckData['members'] = [currentUser.uid];
      batch.set(deckRef, deckData);
      List<Doc> initPlanks = switch (deck.methodology) {
        Methodology.Kanban => [
          {'title': 'To Do', 'color': Colours.NOTOK.toHex()},
          {'title': 'In Progress', 'color': Colours.INOK.toHex()},
          {'title': 'Done', 'color': Colours.OK.toHex()},
        ],
        Methodology.Scrum => [
          {'title': 'Backlog', 'color': Colours.INOK.toHex()},
          {'title': 'Sprint-0', 'color': Colours.OK.toHex()},
        ],
      };
      for (int i = 0; i < initPlanks.length; i++) {
        final plankRef = deckRef.collection('planks').doc();
        batch.set(plankRef, {
          'title': initPlanks[i]['title'],
          'color': initPlanks[i]['color'],
          'order': i,
        });
      }
    } else {
      batch.set(deckRef, deckData, SetOptions(merge: true));
    }
    await batch.commit();
  }

  /// save plank resource
  static Future<void> savePlank(
    String deckId,
    TaskPlank plank,
    int order,
  ) async {
    await getPlanks(deckId).doc(plank.id).set({
      'title': plank.title,
      'color': plank.color.toHex(),
      'order': order,
    }, SetOptions(merge: true));
  }

  /// save block resource
  static Future<void> saveBlock(
    String deckId,
    String plankId,
    TaskBlock block,
    int order,
  ) async {
    await getBlocks(deckId).doc(block.id).set({
      'plankId': plankId,
      'title': block.title,
      'description': block.description,
      'priority': block.priority?.name,
      'deadline': block.deadline,
      'assignee': block.assignee,
      if (block is AdvancedTaskBlock) 'status': block.status,
      if (block is AdvancedTaskBlock) 'points': block.points?.name,
      if (block is AdvancedTaskBlock) 'role': block.role,
      if (block is AdvancedTaskBlock) 'notes': block.notes,
      'order': order,
    }, SetOptions(merge: true));
  }

  // UPDATEs
  /// update planks order by deck id
  static Future<void> updatePlanksOrder(
    String deckId,
    DetailedTaskDeck deck,
  ) async {
    final batch = FirebaseFirestore.instance.batch();
    for (int i = 0; i < deck.length; i++) {
      final plank = deck[i];
      batch.update(getPlanks(deckId).doc(plank.id), {'order': i});
    }
    await batch.commit();
  }

  /// update blocks order by deck, plank id
  static Future<void> updateBlocksOrder(String deckId, TaskPlank plank) async {
    final batch = FirebaseFirestore.instance.batch();
    for (int i = 0; i < plank.length; i++) {
      final task = plank[i];
      batch.update(getBlocks(deckId).doc(task.id), {
        'plankId': plank.id,
        'order': i,
      });
    }
    await batch.commit();
  }

  // DELETEs
  /// delete deck resource by id
  static Future<void> deleteDeck(String id) async {
    final deckRef = getDecks().doc(id);
    try {
      final planksSnapshot = await getPlanks(id).get();
      final blocksSnapshot = await getBlocks(id).get();
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in planksSnapshot.docs) batch.delete(doc.reference);
      for (final doc in blocksSnapshot.docs) batch.delete(doc.reference);
      batch.delete(deckRef);
      await batch.commit();
    } catch (exc) {
      debugPrint('? ERROR: deleting deck; $exc');
      rethrow;
    }
  }

  /// delete plank resource by deck, self id
  static Future<void> deletePlank(String deckId, String id) async {
    try {
      await getPlanks(deckId).doc(id).delete();
    } catch (exc) {
      debugPrint('? ERROR: deleting plank; $exc');
      rethrow;
    }
  }

  /// delete block resource by deck, self id
  static Future<void> deleteBlock(String deckId, String id) async {
    try {
      await getBlocks(deckId).doc(id).delete();
    } catch (exc) {
      debugPrint('? ERROR: deleting block; $exc');
      rethrow;
    }
  }
}
