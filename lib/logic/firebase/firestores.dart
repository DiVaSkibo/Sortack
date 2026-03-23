import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/logic/firebase/documents.dart';
import 'package:sortack/logic/firebase/authentications.dart';
import 'package:sortack/logic/task/blocks.dart';
import 'package:sortack/logic/task/planks.dart';
import 'package:sortack/logic/task/decks.dart';

/// firestore resources - load, save, update and other resources
final class FireRources {
  // GETs
  /// get document query of user
  static Query<Document> getUserDecks(User user) => FirebaseFirestore.instance
      .collection('decks')
      .where('members', arrayContains: user.uid);

  /// get document collection reference of all decks
  static CollectionReference<Document> getDecks() =>
      FirebaseFirestore.instance.collection('decks');

  /// get document collection reference of all planks by id
  static CollectionReference<Document> getPlanks(String id) =>
      getDecks().doc(id).collection('planks');

  /// get document collection reference of all blocks by id
  static CollectionReference<Document> getBlocks(String id) =>
      getDecks().doc(id).collection('blocks');

  // LOADs
  /// load deck details resource by doc
  static DeckDetails loadDeckDetails(DocumentSnapshot doc) {
    final data = doc.data() as Document;
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
  static Future<T> loadDeck<T extends Deck>(String deckId) async {
    final deckRef = getDecks().doc(deckId);
    final snapshots = await Future.wait([
      deckRef.get(),
      deckRef.collection('planks').orderBy('order').get(),
      deckRef.collection('blocks').orderBy('order').get(),
    ]);
    final deckSnapshot = snapshots[0] as DocumentSnapshot;
    final planksSnapshot = snapshots[1] as QuerySnapshot;
    final blocksSnapshot = snapshots[2] as QuerySnapshot;
    if (!deckSnapshot.exists) throw Exception('? Deck is not found');

    // deck planks
    final Map<String, Plank> planksMap = {};
    final planks = switch (T) {
      const (AdvancedDeck) => <AdvancedPlank>[],
      _ => <Plank>[],
    };
    for (var doc in planksSnapshot.docs) {
      final plank = switch (T) {
        const (AdvancedDeck) => loadPlank<AdvancedPlank>(doc),
        _ => loadPlank<Plank>(doc),
      };
      planksMap[doc.id] = plank;
      planks.add(plank);
    }
    // blocks for each deck planks
    for (var doc in blocksSnapshot.docs) {
      final block = switch (T) {
        const (AdvancedDeck) => loadBlock<AdvancedBlock>(doc),
        _ => loadBlock<Block>(doc),
      };
      final data = doc.data() as Document;
      final plankId = data['plankId'] as String?;
      if (plankId != null && planksMap.containsKey(plankId))
        planksMap[plankId]!.blocks.add(block);
      else if (planks.isNotEmpty)
        planks.first.blocks.add(block);
    }

    final details = loadDeckDetails(deckSnapshot);
    return switch (T) {
      const (AdvancedDeck) =>
        AdvancedDeck(details: details, planks: planks as List<AdvancedPlank>)
            as T,
      _ => DetailedDeck(details: details, planks: planks) as T,
    };
  }

  /// load plank resource by doc
  static T loadPlank<T extends Plank>(DocumentSnapshot docsnap) {
    return docToPlank(docsnap.data() as Document, docsnap.id) as T;
  }

  /// load block resource by doc
  static T loadBlock<T extends Block>(DocumentSnapshot docsnap) {
    return docToBlock<T>(docsnap.data() as Document, docsnap.id) as T;
  }

  // SAVEs
  /// save deck details resource
  static Future<void> saveProject(DeckDetails details) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('? User is not authorised...');
    final isNew = details.id.isEmpty || details.id == '#';
    final deckRef = isNew ? getDecks().doc() : getDecks().doc(details.id);
    final batch = FirebaseFirestore.instance.batch();
    final deckData = detailsToDoc(details);
    if (isNew) {
      deckData['created'] = FieldValue.serverTimestamp();
      deckData['owner'] = currentUser.uid;
      deckData['members'] = [currentUser.uid];
      batch.set(deckRef, deckData);
      List<Document> initPlanks = switch (details.methodology) {
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
  static Future<void> savePlank(String deckId, Plank plank, int order) async {
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
    Block block,
    int order,
  ) async {
    await getBlocks(deckId)
        .doc(block.id)
        .set(blockToDoc(block, plankId, order), SetOptions(merge: true));
  }

  // UPDATEs
  /// update planks order by deck id
  static Future<void> updatePlanksOrder(
    String deckId,
    DetailedDeck deck,
  ) async {
    final batch = FirebaseFirestore.instance.batch();
    for (int i = 0; i < deck.length; i++) {
      final plank = deck[i];
      batch.update(getPlanks(deckId).doc(plank.id), {'order': i});
    }
    await batch.commit();
  }

  /// update blocks order by deck, plank id
  static Future<void> updateBlocksOrder(String deckId, Plank plank) async {
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
