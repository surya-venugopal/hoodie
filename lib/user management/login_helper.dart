import 'package:firebase_auth/firebase_auth.dart';

class LoginHelper {
  static Future<void> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }
}
