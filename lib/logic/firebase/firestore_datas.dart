import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/logic/task/decks.dart';

final class FirestoreResources {
  static DeckDetails loadDeckDetails(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    String name = data['name'];
    String? description = data['description'];
    Methodology methodology =
        Methodology.values.asNameMap()[data['methodology']] ??
        Methodology.Kanban;
    DateTime created = (data['created'] as Timestamp).toDate();
    String owner = data['owner'];
    List<String>? members = List<String>.from(data['members'] ?? []);

    return DeckDetails(
      name: name,
      description: description,
      methodology: methodology,
      created: created,
      owner: owner,
      members: members,
    );
  }
}
