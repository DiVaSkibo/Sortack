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
      decoration: Decorations.DECK_BOX,
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
      decoration: Decorations.SURFACE_BOX,
      child: child,
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
            style: Styles.TASK_TITLE_TEXT,
            decoration: Decorations.cardInput(
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
            style: Styles.TASK_TITLE_TEXT,
            decoration: Decorations.cardInput(
              collapsed: true,
              hintText: 'I have to do ...',
            ),
          ),
          FilledButton(
            onPressed: () async {
              dynamic user = await _auth.register(
                email: _authController.email,
                password: _authController.password,
              );
              if (user == null)
                debugPrint('! error with registering user...');
              else
                debugPrint('registered user: $user');
            },
            child: Text('Register'),
          ),
          FilledButton(
            onPressed: () async {
              dynamic user = await _auth.signIn(
                email: _authController.email,
                password: _authController.password,
              );
              if (user == null)
                debugPrint('! error with signing in user...');
              else
                debugPrint('signed in user: $user');
            },
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
