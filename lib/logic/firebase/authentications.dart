import 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sortack/logic/firebase/documents.dart';
import 'package:sortack/logic/firebase/firestores.dart';
import 'package:sortack/tool/consts.dart';

class AuthHandler {
  static FirebaseAuth get _auth => FirebaseAuth.instance;
  static GoogleSignIn get _googleSignIn => GoogleSignIn(
    clientId:
        '441522416299-dauq6s84p2n594rv019di2lqpmfl15qb.apps.googleusercontent.com',
  );

  AuthHandler._();

  static Future<User?> signUpin({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (signInError) {
      if (signInError.code == 'user-not-found' ||
          signInError.code == 'invalid-credential' ||
          signInError.code == 'wrong-password') {
        try {
          final userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          final user = userCredential.user;
          if (user != null) {
            final profile = UserProfile(
              id: user.uid,
              name: email.split('@').first,
              email: user.email ?? email,
              avatar: randAvatar(),
            );
            await FireRources.saveUserProfile(profile);
          }
          return user;
        } on FirebaseAuthException catch (signUpError) {
          if (signUpError.code == 'email-already-in-use') {
            throw Exception('? WARNING: wrong password');
          } else if (signUpError.code == 'weak-password') {
            throw Exception('? WARNING: weak password');
          }
          throw Exception(
            signUpError.message ?? '! ERROR: on signing up user...',
          );
        }
      }
      throw Exception(signInError.message ?? '! ERROR: on signing in...');
    }
  }

  static Future<User?> signInWithGoogle() async {
    try {
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) return null;
      final googleAuth = await googleAccount.authentication;
      final oauthCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final userCredential = await _auth.signInWithCredential(oauthCredential);
      final user = userCredential.user;
      if (user != null &&
          (userCredential.additionalUserInfo?.isNewUser ?? false)) {
        final profile = UserProfile(
          id: user.uid,
          name: user.displayName ?? 'customer',
          email: user.email ?? '',
          avatar: user.photoURL ?? '',
        );
        await FireRources.saveUserProfile(profile);
      }
      return user;
    } on FirebaseAuthException catch (exc) {
      throw Exception('ERROR: on google sign in: ${exc.message}');
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  static Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exc) {
      throw Exception(exc.message);
    }
  }
}
