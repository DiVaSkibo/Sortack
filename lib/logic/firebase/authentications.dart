import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHandler {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> register({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseException catch (exc) {
      throw Exception(exc.message ?? '! ERROR: on registering user...');
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
    } on FirebaseException catch (exc) {
      throw Exception(exc.message ?? '! ERROR: on signing in...');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final googleAccount = await GoogleSignIn.instance.authenticate();
      final oauthCred = GoogleAuthProvider.credential(
        idToken: googleAccount.authentication.idToken,
      );
      final userCred = await _auth.signInWithCredential(oauthCred);
      return userCred.user;
    } on FirebaseException catch (exc) {
      throw Exception(exc.message);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn.instance.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (exc) {
      throw Exception(exc);
    }
  }
}
