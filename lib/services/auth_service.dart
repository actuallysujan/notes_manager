import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //Making it singleton
  AuthService._();

  static final AuthService instance = AuthService._();

  //Signup

  Future<String?> signup(String name, String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user?.updateDisplayName(name);

      return null; // success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'An account already exists for that email.';
        case 'invalid-email':
          return 'That email address is invalid.';
        case 'weak-password':
          return 'Password is too weak (use 6+ characters).';
        case 'operation-not-allowed':
          return 'Email/password sign-up is not enabled.';
        default:
          return e.message ?? 'Sign up failed.';
      }
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'invalid-email':
          return 'That email address is invalid.';
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'user-disabled':
          return 'This account has been disabled.';
        default:
          return e.message ?? 'Login failed.';
      }
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
}
