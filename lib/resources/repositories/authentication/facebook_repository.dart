import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookAuthRepository {

  final facebookLogin = FacebookLogin();

  loginWithFB() async {
    final FacebookLoginResult facebookLoginResult =
    await facebookLogin.logIn(['email', 'public_profile']);
    FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
    return facebookAccessToken.token;
  }


  logoutFB() async {
    await facebookLogin.logOut();
  }
}
