import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHandler {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '441522416299-dauq6s84p2n594rv019di2lqpmfl15qb.apps.googleusercontent.com',
  );

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (exc) {
      throw Exception(exc.message ?? '! ERROR: on signing up user...');
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (exc) {
      throw Exception(exc.message ?? '! ERROR: on signing in...');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) return null;
      final googleAuth = await googleAccount.authentication;
      final oauthCred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final userCred = await _auth.signInWithCredential(oauthCred);
      return userCred.user;
    } on FirebaseAuthException catch (exc) {
      throw Exception('ERROR: google sign in: ${exc.message}');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exc) {
      throw Exception(exc.message);
    }
  }
}
