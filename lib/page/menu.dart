import 'package:sortack/_logics.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_widgets.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final profile = await FireRources.loadUserProfile(uid);
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null)
      return Center(child: Icon(Icons.error_outline_rounded));
    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 30,
                children: [
                  ProfileAvatar(name: _profile!.name, avatar: _profile!.avatar),
                  Text(_profile!.name),
                ],
              ),
      ),
      body: Ground(
        scrollable: true,
        child: StreamBuilder(
          stream: FireRources.getUserDecks(currentUser).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError)
              return Center(
                child: ListTile(
                  leading: Icon(Icons.error_outline_rounded),
                  trailing: Text(snapshot.error.toString()),
                ),
              );
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
              return Icon(Icons.cabin_rounded);
            return Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 50,
              runSpacing: 100,
              children: snapshot.data!.docs
                  .map(
                    (doc) => ProjectCard(
                      key: ValueKey(doc.id),
                      details: FireRources.loadProjectDetails(doc),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
      floatingActionButton: Wrap(
        children: [
          FloatingActionButton(
            heroTag: 'btnCreateProject',
            child: Icon(Icons.add_box_rounded),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ProjectGradialog(),
            ),
          ),
          FloatingActionButton(
            heroTag: 'btnJoinProject',
            onPressed: () => showDialog(
              context: context,
              builder: (context) => JoinGradialog(),
            ),
            child: Icon(Icons.travel_explore_rounded),
          ),
        ],
      ),
    );
  }
}
