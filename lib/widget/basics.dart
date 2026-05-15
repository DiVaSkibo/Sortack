import 'dart:ui';
import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';

/// build progress indicator
Widget buildLoading({double size = 90.0}) => SizedBox.square(
  dimension: size,
  child: CircularProgressIndicator(strokeWidth: size / 5.0),
);

/// build random easter egg icon
Icon buildEasterEgg({double size = 120.0}) =>
    Icon(randEasterEggIcon(), size: size, color: Colours.CANVAS_AC);

/// ground widget - filled page background
class Ground extends StatelessWidget {
  final bool scrollable;
  final bool over;
  final bool tabs;
  final Widget child;

  const Ground({
    super.key,
    this.scrollable = false,
    this.over = false,
    this.tabs = false,
    required this.child,
  });

  double xWidth(BuildContext context) => MediaQuery.of(context).size.width;
  double xHeight(BuildContext context) =>
      MediaQuery.of(context).size.height -
      (over
          ? tabs
                ? 120.0
                : 80.0
          : 0.0);

  @override
  Widget build(BuildContext context) {
    final parent = Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(gradient: Gradients.DECK),
      constraints: BoxConstraints.fromViewConstraints(
        ViewConstraints(minWidth: xWidth(context), minHeight: xHeight(context)),
      ),
      child: child,
    );
    return scrollable ? SingleChildScrollView(child: parent) : parent;
  }
}

class Overground extends StatelessWidget implements PreferredSizeWidget {
  final IconData? icon;
  final UserProfile? profile;
  final String? title;
  final Color? iconColor;
  final List<Widget>? actions;
  final TabController? tabController;
  final List<IconData>? tabIcons;
  final List<String>? tabTitles;
  final VoidCallback? onRender;

  const Overground({
    super.key,
    this.icon,
    this.profile,
    this.title,
    this.iconColor = Colours.F,
    this.actions,
    this.tabController,
    this.tabIcons,
    this.tabTitles,
    this.onRender,
  });

  const Overground.loading({super.key})
    : icon = null,
      profile = null,
      title = null,
      iconColor = null,
      actions = null,
      tabController = null,
      tabIcons = null,
      tabTitles = null,
      onRender = null;

  @override
  Size get preferredSize => Size.fromHeight(
    tabIcons != null && tabIcons!.isNotEmpty ||
            tabTitles != null && tabTitles!.isNotEmpty
        ? 120.0
        : 80.0,
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      leadingWidth: 300.0,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: Gradients.UPDECK),
        constraints: BoxConstraints.fromViewConstraints(
          ViewConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: preferredSize.height,
          ),
        ),
        child:
            icon == null && profile == null && title == null && actions == null
            ? Center(child: buildLoading(size: 40.0))
            : Align(
                alignment: AlignmentGeometry.topCenter,
                child: SizedBox(
                  height: 80.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 30,
                    children: [
                      if (profile != null) ProfileAvatar(profile: profile!),
                      if (profile != null)
                        Text(profile!.name, style: Styles.TEXT_OVER),
                      if (icon != null) Icon(icon, size: 50, color: iconColor),
                      if (title != null) Text(title!, style: Styles.TEXT_OVER),
                    ],
                  ),
                ),
              ),
      ),
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 15,
          children: [
            SvgPicture.asset('assets/icon/Sortack.svg', height: 60.0),
            Text(
              'Sortack',
              style: TextStyle(
                fontFamily: Fonts.RUBIK_MARKER_HATCH,
                fontSize: 21,
              ),
            ),
            if (onRender != null)
              IconButton(
                icon: Icon(
                  Icons.autorenew_rounded,
                  size: 17,
                  color: Colours.INK_AC,
                ),
                onPressed: onRender,
              ),
          ],
        ),
      ),
      actions: actions,
      bottom:
          tabIcons != null && tabIcons!.isNotEmpty ||
              tabTitles != null && tabTitles!.isNotEmpty
          ? TabBar(
              controller: tabController,
              tabs: [
                for (
                  int i = 0;
                  i < min(tabIcons!.length, tabTitles!.length);
                  i++
                )
                  Tab(
                    height: 35.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Icon(tabIcons![i]),
                        Text(
                          tabTitles![i],
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: Fonts.RUBIK,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )
          : null,
    );
  }
}

/// surface widget - filled container background
class Surface extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Widget child;
  final List<Widget>? actions;

  const Surface({
    super.key,
    this.padding,
    this.width,
    this.height,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Container(
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: Gradients.SURFACE,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: child,
    );
    return actions == null
        ? surface
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 30.0,
            children: [
              surface,
              SizedBox(
                width: 300.0,
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  runAlignment: WrapAlignment.center,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: actions!,
                ),
              ),
            ],
          );
  }
}

/// profile avatar widget
class ProfileAvatar extends StatelessWidget {
  final UserProfile profile;
  final double radius;

  const ProfileAvatar({super.key, required this.profile, this.radius = 30.0});

  @override
  Widget build(BuildContext context) {
    if (profile.avatar.isEmpty)
      FireRources.saveUserProfile(
        UserProfile(
          id: profile.id,
          name: profile.id,
          email: profile.email,
          avatar: randAvatar(),
        ),
      );
    if (kIsWeb) {
      final String viewId = 'avatar-image-${profile.avatar.hashCode}';
      ui_web.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
        final web.HTMLImageElement img = web.HTMLImageElement()
          ..src = profile.avatar
          ..style.borderRadius = '50%'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = 'cover';
        return img;
      });
      return SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: HtmlElementView(viewType: viewId),
      );
    } else
      return CachedNetworkImage(
        imageUrl: profile.avatar,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
          backgroundColor: Colours.CANVAS_UN,
        ),
        placeholder: (context, url) => buildLoading(size: 24.0),
        errorWidget: (context, url, error) =>
            CircleAvatar(backgroundColor: Colours.BAD),
      );
  }
}

/// authentication view widget
class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final AuthController _authController = AuthController();

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Surface(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      width: 300,
      // ignore: sort_child_properties_last
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runAlignment: WrapAlignment.center,
        runSpacing: 15,
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _authController.emailController,
            focusNode: _authController.emailFocus,
            onEditingComplete: () => _authController.emailFocus.unfocus(),
            onTapOutside: (event) => _authController.emailFocus.unfocus(),
            style: TextStyle(
              fontSize: 17,
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
              color: Colours.F,
            ),
            decoration: Decorations.INPUT_FIELD(
              hintText: 'My email is ...',
              tipColor: Colours.INK,
            ),
          ),
          TextField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: _authController.passwordController,
            focusNode: _authController.passwordFocus,
            onEditingComplete: () => _authController.passwordFocus.unfocus(),
            onTapOutside: (event) => _authController.passwordFocus.unfocus(),
            style: TextStyle(
              fontSize: 17,
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w500,
              color: Colours.F,
            ),
            decoration: Decorations.INPUT_FIELD(
              hintText: 'My password is ...',
              tipColor: Colours.INK,
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          style: Styles.BUTTON_LARGE,
          child: BorderedText(
            strokeColor: Colours.O,
            strokeWidth: 4,
            child: Text(
              'Join it',
              style: const TextStyle(
                fontSize: 17,
                fontFamily: Fonts.RUBIK,
                color: Colours.SHIFT,
              ),
            ),
          ),
          onPressed: () async {
            dynamic user = await AuthHandler.signUpin(
              email: _authController.email,
              password: _authController.password,
            );
            if (user == null)
              debugPrint(
                '! ERROR: on joining it; sign in/up user; user is empty...',
              );
          },
        ),
        OutlinedButton.icon(
          iconAlignment: IconAlignment.end,
          style: Styles.BUTTON_LARGE,
          icon: SvgPicture.asset('assets/icon/foreign/Google.svg', height: 20),
          label: BorderedText(
            strokeColor: Colours.O,
            strokeWidth: 4,
            child: Text(
              ' Use',
              style: const TextStyle(
                fontSize: 17,
                fontFamily: Fonts.RUBIK,
                color: Colours.SHIFT,
              ),
            ),
          ),
          onPressed: () async {
            try {
              dynamic user = await AuthHandler.signInWithGoogle();
              if (user == null)
                debugPrint(
                  '! ERROR: on signing in user with Google; user is empty...',
                );
            } catch (exc) {
              debugPrint('! ERROR: $exc');
            }
          },
        ),
      ],
    );
  }
}
