import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
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

  const Surface({
    super.key,
    this.padding,
    this.width,
    this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: Gradients.SURFACE,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: child,
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
      width: 300,
      height: 300,
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 11,
        runSpacing: 22,
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _authController.emailController,
            focusNode: _authController.emailFocus,
            onEditingComplete: () => _authController.emailFocus.unfocus(),
            onTapOutside: (event) => _authController.emailFocus.unfocus(),
            style: Styles.TEXT_INPUT,
            decoration: Decorations.INPUT_FIELD(
              collapsed: true,
              hintText: 'I have to do ...',
            ),
          ),
          TextField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: _authController.passwordController,
            focusNode: _authController.passwordFocus,
            onEditingComplete: () => _authController.passwordFocus.unfocus(),
            onTapOutside: (event) => _authController.passwordFocus.unfocus(),
            style: Styles.TEXT_INPUT,
            decoration: Decorations.INPUT_FIELD(
              collapsed: true,
              hintText: 'I have to do ...',
            ),
          ),
          FilledButton(
            onPressed: () async {
              dynamic user = await _auth.signUp(
                email: _authController.email,
                password: _authController.password,
              );
              if (user == null) debugPrint('! error with signing up user...');
            },
            child: Text('Sign up'),
          ),
          FilledButton(
            onPressed: () async {
              dynamic user = await _auth.signIn(
                email: _authController.email,
                password: _authController.password,
              );
              if (user == null) debugPrint('! error with signing in user...');
            },
            child: Text('Sign in'),
          ),
          OutlinedButton.icon(
            iconAlignment: IconAlignment.end,
            onPressed: () async {
              try {
                dynamic user = await _auth.signInWithGoogle();
                if (user == null) debugPrint('! error with signing in user...');
              } catch (exc) {
                debugPrint('ERROR: $exc');
              }
            },
            label: Text('Use'),
            icon: SvgPicture.asset(
              'assets/icon/foreign/Google.svg',
              height: 16,
            ),
          ),
        ],
      ),
    );
  }
}
