import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/logic/firebase/authentications.dart';
import 'package:sortack/logic/opjects.dart';
import 'package:sortack/logic/task/blocks.dart';
import 'package:sortack/logic/task/planks.dart';
import 'package:sortack/logic/task/decks.dart';

final class FirestoreResources {
  static Stream<QuerySnapshot<Map<String, dynamic>>> loadUserProjects(
    User user,
  ) => FirebaseFirestore.instance
      .collection('projects')
      .where('members', arrayContains: user.uid)
      .snapshots();

  static DocumentReference<Map<String, dynamic>> loadProjectDeck(String id) =>
      FirebaseFirestore.instance.collection('projects').doc(id);
  static DocumentReference<Map<String, dynamic>> loadDeckBlocks(
    String deckId,
  ) => FirebaseFirestore.instance
      .collection('projects')
      .doc(deckId)
      .collection('blocks')
      .doc();

  static DeckDetails loadProject(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
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

  static Future<void> saveProject(DeckDetails project) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('User is not authorised...');
    final instance = FirebaseFirestore.instance;
    final projectRef = instance.collection('projects').doc();
    final batch = instance.batch();
    batch.set(projectRef, {
      'name': project.name.trim(),
      'description': project.description,
      'methodology': project.methodology.name,
      'created': FieldValue.serverTimestamp(),
      'owner': currentUser.uid,
      'members': [currentUser.uid],
    });
    List<Map<String, dynamic>> initPlanks = switch (project.methodology) {
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
      final plankRef = projectRef.collection('planks').doc();
      batch.set(plankRef, {
        'title': initPlanks[i]['title'],
        'color': initPlanks[i]['color'],
        'order': i,
      });
    }
    await batch.commit();
  }

  static Future<DetailedTaskDeck> loadDeck(String deckId) async {
    final projectRef = FirebaseFirestore.instance
        .collection('projects')
        .doc(deckId);
    final results = await Future.wait([
      projectRef.get(),
      projectRef.collection('planks').orderBy('order').get(),
      projectRef.collection('blocks').get(),
    ]);
    final projectDoc = results[0] as DocumentSnapshot;
    final planksSnapshot = results[1] as QuerySnapshot;
    final blocksSnapshot = results[2] as QuerySnapshot;
    if (!projectDoc.exists) throw Exception('? Project not found');
    final details = loadProject(projectDoc);
    final Map<String, TitledTaskPlank> planksMap = {};
    final List<TitledTaskPlank> planksList = [];
    for (var doc in planksSnapshot.docs) {
      final plank = loadPlank(doc);
      planksMap[doc.id] = plank;
      planksList.add(plank);
    }
    for (var doc in blocksSnapshot.docs) {
      final block = loadBlock(doc);
      final data = doc.data() as Map<String, dynamic>;
      final plankId = data['plankId'] as String?;
      if (plankId != null && planksMap.containsKey(plankId))
        planksMap[plankId]!.blocks.add(block);
      else if (planksList.isNotEmpty)
        planksList.first.blocks.add(block);
    }
    return DetailedTaskDeck(details: details, planks: planksList);
  }

  static TitledTaskPlank loadPlank(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TitledTaskPlank(
      id: doc.id,
      title: data['title'] ?? '',
      color: data['color'] != null
          ? ColorExtension.fromHex(data['color'])
          : Colours.W,
      blocks: [],
    );
  }

  static Future<void> savePlanks(
    String deckId,
    TitledTaskPlank plank,
    int order,
  ) async {
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(deckId)
        .collection('planks')
        .add({
          'title': plank.title,
          'color': plank.color.toHex(),
          'order': order,
        });
  }

  static TaskBlock loadBlock(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskBlock(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: TaskStatus.values.asNameMap()[data['status']] ?? TaskStatus.toDo,
      priority: data['priority'] != null
          ? TaskPriority.values.asNameMap()[data['priority']]
          : null,
      points: data['points'] != null
          ? TaskPointsTShirt.values.asNameMap()[data['points']]
          : null,
      role: data['role'],
      assignee: data['assignee'],
      notes: data['notes'] ?? '',
    );
  }

  static Future<void> saveBlock(
    String deckId,
    String plankId,
    TaskBlock block,
  ) async {
    final docRef = FirebaseFirestore.instance
        .collection('projects')
        .doc(deckId)
        .collection('blocks')
        .doc(block.id);
    await docRef.set({
      'plankId': plankId,
      'title': block.title,
      'description': block.description,
      'status': block.status.name,
      'priority': block.priority?.name,
      'points': block.points?.name,
      'role': block.role,
      'assignee': block.assignee,
      'notes': block.notes,
    });
  }
}
