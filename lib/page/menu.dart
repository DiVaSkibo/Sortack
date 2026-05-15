import 'package:sortack/_logics.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_widgets.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  UserProfile? profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final loadedProfile = await FireRources.loadUserProfile(uid);
      setState(() {
        profile = loadedProfile;
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
      appBar: _isLoading
          ? const Overground.loading()
          : Overground(
              profile: profile!,
              actions: [
                IconButton(
                  onPressed: () async {
                    await AuthHandler.signOut();
                  },
                  icon: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Colours.INK_UN,
                  ),
                ),
              ],
              onRender: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                );
              },
            ),
      body: Ground(
        scrollable: true,
        over: true,
        child: StreamBuilder(
          stream: FireRources.getUserDecks(currentUser).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: buildLoading());
            if (snapshot.hasError)
              return Center(
                child: ListTile(
                  leading: Icon(Icons.error_outline_rounded),
                  trailing: Text(snapshot.error.toString()),
                ),
              );
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
              return Center(child: buildEasterEgg());
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
        spacing: 20,
        runSpacing: 20,
        children: [
          FloatingActionButton(
            heroTag: 'btnCreateProject',
            child: Icon(
              Icons.add_box_rounded,
              shadows: List.generate(
                30,
                (index) => const Shadow(blurRadius: 1.15, color: Colours.O),
              ),
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => ProjectGradialog(),
            ),
          ),
          FloatingActionButton(
            heroTag: 'btnJoinProject',
            child: Icon(
              Icons.travel_explore_rounded,
              shadows: List.generate(
                30,
                (index) => const Shadow(blurRadius: 1.15, color: Colours.O),
              ),
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => JoinGradialog(),
            ),
          ),
        ],
      ),
    );
  }
}
