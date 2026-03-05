import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/logic/task/decks.dart';
import 'package:sortack/logic/firebase/authentications.dart';

final class FirestoreResources {
  static Stream<QuerySnapshot<Map<String, dynamic>>> loadUserProjects(
    User user,
  ) => FirebaseFirestore.instance
      .collection('projects')
      .where('members', arrayContains: user.uid)
      .snapshots();

  static DeckDetails loadProject(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    String name = data['name'];
    String? description = data['description'];
    Methodology methodology =
        Methodology.values.asNameMap()[data['methodology']] ??
        Methodology.Kanban;
    DateTime created = data['created'] != null
        ? (data['created'] as Timestamp).toDate()
        : DateTime.now();
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

  static Future<void> saveProject(DeckDetails project) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('User is not authorised...');
    await FirebaseFirestore.instance.collection('projects').add({
      'name': project.name.trim(),
      'description': project.description,
      'methodology': project.methodology.name,
      'created': FieldValue.serverTimestamp(),
      'owner': currentUser.uid,
      'members': [currentUser.uid],
    });
  }
}
