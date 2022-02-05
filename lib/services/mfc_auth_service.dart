import 'package:firebase_auth/firebase_auth.dart';

class MFCAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Stream<User?> userStream() => auth.authStateChanges();

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-disabled') {
          return 'User has been disabled. Contact support for more information';
        } else {
          return 'Invalid email or password';
        }
      }
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
