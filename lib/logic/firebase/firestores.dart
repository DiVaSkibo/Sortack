import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/logic/firebase/documents.dart';
import 'package:sortack/logic/firebase/authentications.dart';
import 'package:sortack/logic/_tasks.dart';

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

  /// load map deck resource by id
  static Future<T> loadMapDeck<T extends MapDeck>(
    String id, {
    required List<String> keys,
  }) async {
    final deckRef = getDecks().doc(id);
    final snapshots = await Future.wait([
      deckRef.get(),
      deckRef.collection('planks').orderBy('order').get(),
      deckRef.collection('blocks').orderBy('order').get(),
    ]);
    final deckSnapshot = snapshots[0] as DocumentSnapshot;
    final planksSnapshot = snapshots[1] as QuerySnapshot;
    final blocksSnapshot = snapshots[2] as QuerySnapshot;
    if (!deckSnapshot.exists) throw Exception('? Deck is not found');

    // map deck planks
    final Map planks = <String, List>{
      for (var key in keys)
        key: switch (T) {
          const (AdvancedMapDeck) => <AdvancedPlank>[],
          _ => <Plank>[],
        },
    };
    final Map planksMap = switch (T) {
      const (AdvancedMapDeck) => <String, AdvancedPlank>{},
      _ => <String, Plank>{},
    };
    for (var doc in planksSnapshot.docs) {
      final plank = switch (T) {
        const (AdvancedMapDeck) => loadPlank<AdvancedPlank>(doc),
        _ => loadPlank<Plank>(doc),
      };
      final data = doc.data() as Document;
      final key = data['key'] as String? ?? keys.first;
      planksMap[doc.id] = plank;
      if (!planks.containsKey(key))
        planks[key] = switch (T) {
          const (AdvancedMapDeck) => <AdvancedPlank>[],
          _ => <Plank>[],
        };
      planks[key]!.add(plank);
    }

    // map deck blocks
    for (var doc in blocksSnapshot.docs) {
      final block = switch (T) {
        const (AdvancedMapDeck) => loadBlock<AdvancedBlock>(doc),
        _ => loadBlock<Block>(doc),
      };
      final data = doc.data() as Document;
      final plankId = data['plankId'] as String?;
      if (plankId != null && planksMap.containsKey(plankId))
        planksMap[plankId]!.blocks.add(block);
    }

    // map deck decks
    final decks = switch (T) {
      const (AdvancedMapDeck) => <String, AdvancedDeck>{},
      _ => <String, Deck>{},
    };
    for (var entry in planks.entries) {
      decks[entry.key] = switch (T) {
        const (AdvancedMapDeck) => AdvancedDeck(
          planks: entry.value as List<AdvancedPlank>,
        ),
        _ => Deck(planks: entry.value as List<Plank>),
      };
    }

    return switch (T) {
      const (AdvancedMapDeck) =>
        AdvancedMapDeck(decks: decks as Map<String, AdvancedDeck>) as T,
      _ => MapDeck(decks: decks) as T,
    };
  }

  /// load deck resource by id
  static Future<T> loadDeck<T extends Deck>(String id) async {
    final deckRef = getDecks().doc(id);
    final snapshots = await Future.wait([
      deckRef.get(),
      deckRef.collection('planks').orderBy('order').get(),
      deckRef.collection('blocks').orderBy('order').get(),
    ]);
    final deckSnapshot = snapshots[0] as DocumentSnapshot;
    final planksSnapshot = snapshots[1] as QuerySnapshot;
    final blocksSnapshot = snapshots[2] as QuerySnapshot;
    if (!deckSnapshot.exists) throw Exception('? Deck is not found');
    final details = loadDeckDetails(deckSnapshot);

    // deck planks
    final Map planksMap = switch (T) {
      const (AdvancedDeck) => <String, AdvancedPlank>{},
      _ => <String, Plank>{},
    };
    final List planks = switch (T) {
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

    return switch (T) {
      const (AdvancedDeck) =>
        AdvancedDetailedDeck(
              details: details,
              planks: planks as List<AdvancedPlank>,
            )
            as T,
      _ => DetailedDeck(details: details, planks: planks as List<Plank>) as T,
    };
  }

  /// load plank resource by document
  static T loadPlank<T extends Plank>(DocumentSnapshot docsnap) {
    final doc = docsnap.data() as Document;
    return docToPlank<T>(doc, docsnap.id) as T;
  }

  /// load block resource by document
  static T loadBlock<T extends Block>(DocumentSnapshot docsnap) {
    final doc = docsnap.data() as Document;
    return docToBlock<T>(doc, docsnap.id) as T;
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
          plankToDoc(Plank(id: '#', title: 'To Do', color: Colours.NOTOK), 0),
          plankToDoc(
            Plank(id: '#', title: 'In Progress', color: Colours.INOK),
            1,
          ),
          plankToDoc(Plank(id: '#', title: 'Done', color: Colours.OK), 2),
        ],
        Methodology.Scrum => [
          plankToDoc(
            Plank(id: '#', title: 'Product Backlog', color: Colours.INOK),
            0,
            key: 'Product Backlog',
          ),
        ],
      };
      for (final plank in initPlanks) {
        final plankRef = deckRef.collection('planks').doc();
        batch.set(plankRef, plank);
      }
    } else {
      batch.set(deckRef, deckData, SetOptions(merge: true));
    }
    await batch.commit();
  }

  /// save plank resource
  static Future<void> savePlank(
    String deckId,
    Plank plank,
    int order, {
    String? key,
  }) async {
    await getPlanks(deckId)
        .doc(plank.id)
        .set(plankToDoc(plank, order, key: key), SetOptions(merge: true));
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
