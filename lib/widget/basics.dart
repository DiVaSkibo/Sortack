import 'dart:ui';
import 'dart:ui_web' as ui_web;
import 'package:bordered_text/bordered_text.dart';
import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sortack/_tools.dart';
import 'package:sortack/_logics.dart';

/// ground widget - filled page background
class Ground extends StatelessWidget {
  final bool scrollable;
  final Widget child;

  const Ground({super.key, this.scrollable = false, required this.child});

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: Gradients.DECK),
      constraints: BoxConstraints.fromViewConstraints(
        ViewConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height,
        ),
      ),
      child: child,
    );
    return scrollable ? SingleChildScrollView(child: widget) : widget;
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

/// blink box widget - blinking by click and changing a value
class BlinkBox<T extends Labeling> extends StatefulWidget {
  final List<T> values;
  final List<Color> colors;
  final int index;
  final Function(T)? onBlink;

  const BlinkBox({
    super.key,
    this.index = 0,
    required this.values,
    required this.colors,
    this.onBlink,
  });

  @override
  State<BlinkBox> createState() => _BlinkBoxState<T>();
}

class _BlinkBoxState<T extends Labeling> extends State<BlinkBox> {
  late final List<T> values = widget.values as List<T>;
  late final List<Color> colors = widget.colors;
  late int index = widget.index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          index = (index + 1) % values.length;
        });
        widget.onBlink?.call(values[index]);
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: colors[index],
        child: Center(
          child: Text(
            values[index].label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: Fonts.RUBIK,
              fontWeight: FontWeight.w600,
              color: Colours.BACK_GLOW,
            ),
          ),
        ),
      ),
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
  final AuthHandler _auth = AuthHandler();
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
              color: Colours.W,
            ),
            decoration: Decorations.INPUT_FIELD(hintText: 'My email is ...'),
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
              color: Colours.W,
            ),
            decoration: Decorations.INPUT_FIELD(hintText: 'My password is ...'),
          ),
        ],
      ),
      actions: [
        FilledButton(
          style: Styles.BUTTON_LARGE,
          child: BorderedText(
            strokeColor: Colours.B,
            strokeWidth: 4,
            child: Text(
              'Join it',
              style: const TextStyle(
                fontSize: 17,
                fontFamily: Fonts.RUBIK,
                color: Colours.CENTER,
              ),
            ),
          ),
          onPressed: () async {
            dynamic user = await _auth.joinIt(
              email: _authController.email,
              password: _authController.password,
            );
            if (user == null)
              debugPrint('! ERROR: on joining it; sign in/up user');
          },
        ),
        OutlinedButton.icon(
          iconAlignment: IconAlignment.end,
          style: Styles.BUTTON_LARGE,
          icon: SvgPicture.asset('assets/icon/foreign/Google.svg', height: 20),
          label: BorderedText(
            strokeColor: Colours.B,
            strokeWidth: 4,
            child: Text(
              'Use',
              style: const TextStyle(
                fontSize: 17,
                fontFamily: Fonts.RUBIK,
                color: Colours.CENTER,
              ),
            ),
          ),
          onPressed: () async {
            try {
              dynamic user = await _auth.signInWithGoogle();
              if (user == null) debugPrint('! error with signing in user...');
            } catch (exc) {
              debugPrint('ERROR: $exc');
            }
          },
        ),
      ],
    );
  }
}

/// profile avatar widget
class ProfileAvatar extends StatelessWidget {
  final String name;
  final String? avatar;
  final double radius;

  const ProfileAvatar({
    super.key,
    required this.name,
    this.avatar,
    this.radius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    if (avatar == null || avatar!.isEmpty)
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colours.SHADOW,
        child: Text(name.isNotEmpty ? name[0] : ''),
      );
    if (kIsWeb) {
      final String viewId = 'avatar-image-${avatar.hashCode}';
      ui_web.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
        final web.HTMLImageElement img = web.HTMLImageElement()
          ..src = avatar!
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
        imageUrl: avatar!,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
          backgroundColor: Colours.UNFRONT,
        ),
        placeholder: (context, url) => const SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (context, url, error) =>
            CircleAvatar(backgroundColor: Colours.BAD),
      );
  }
}
