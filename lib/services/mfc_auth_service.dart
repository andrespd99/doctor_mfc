import 'package:doctor_mfc/models/app_user.dart';
import 'package:doctor_mfc/models/auth_exception.dart';
import 'package:doctor_mfc/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Authentication service class.
class MFCAuthService {
  /// [FirebaseAuth] instance.
  FirebaseAuth _auth = FirebaseAuth.instance;

  /// [FirebaseAuth]'s current user. Null if not signed in.
  User? user = FirebaseAuth.instance.currentUser;

  /// Stream of [FirebaseAuth]'s current user. Null if not signed in.
  ///
  /// Can be listened to for changes.
  Stream<User?> userStream() => _auth.authStateChanges();

  /// Sign in with `email` and `password`. Returns [String] if unsuccessful, with
  /// the description of the error.
  ///
  /// The sign in method first gets the user document (if it exists), it will then
  /// check if the user is enabled to enter the app. If the user is not enabled,
  /// it will return an error.
  ///
  /// Then, it will sign in the user with the given credentials and will update any of the
  /// [authStateChanges], [idTokenChanges] or [userChanges] stream listeners..
  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await Database().getUserDocByEmail(email).then((userDoc) {
        bool isDisabled = this.isDisabled(userDoc.data()!);
        if (isDisabled) {
          throw FirebaseAuthException(code: 'user-disabled');
        }
        return _auth.signInWithEmailAndPassword(
            email: email, password: password);
      });
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-disabled') {
          return 'User has been disabled. Contact support for more information';
        } else {
          return 'Invalid email or password';
        }
      } else if (error is AuthException) {
        return error.message;
      } else {
        return 'An error occurred. Please try again later';
      }
    }
  }

  ///   Signs out the current user.
  ///
  /// If successful, it also updates any [authStateChanges], [idTokenChanges] or [userChanges] stream listeners.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Returns `true` if the given user is disabled. Returns `false` otherwise.
  bool isDisabled(AppUser user) {
    bool? disabled = user.disabled;

    return disabled != null && disabled == true;
  }
}
