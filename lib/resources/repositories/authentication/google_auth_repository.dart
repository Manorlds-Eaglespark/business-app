import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthRepository {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount googleUser;

  login() async {
    try {
       googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      return googleAuth.idToken;
    } catch (err) {
      print(err);
    }
  }

  logout() {
    _googleSignIn.signOut();

  }
}
