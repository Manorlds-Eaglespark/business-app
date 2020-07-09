import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mutuuze/models/user_object.dart';
import 'package:mutuuze/resources/api_providers/onboarding/social_auth_api_provider.dart';
import 'package:mutuuze/resources/repositories/authentication/facebook_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'facebook_events.dart';
import 'facebook_states.dart';

class FacebookAuthBloc extends Bloc<FacebookAuthEvent, FacebookAuthState> {

  static const String USERDATA = "USERDATA";

  FacebookAuthRepository _repository = FacebookAuthRepository();
  SocialAuthApiProvider _socialAuthApiProvider = SocialAuthApiProvider();

  FacebookAuthBloc() : super(null);

  StreamController _facebookAuthController = StreamController();

  StreamSink get facebookAuthSink => _facebookAuthController.sink;

  Stream get facebookAuthStream => _facebookAuthController.stream;

  @override
  FacebookAuthState get initialState => FacebookAuthInitialState();

  @override
  Stream<FacebookAuthState> mapEventToState(FacebookAuthEvent event) async* {
    if (event is LoginFacebookAuthEvent) {
      yield FacebookAuthLoadingState();
      try {
        String idToken = await _repository.loginWithFB();
        UserObject userData =
            await _socialAuthApiProvider.fetchServerToken(idToken, 'facebook');
        SharedPreferences prefs =
            await SharedPreferences.getInstance();
        prefs.setString(USERDATA, userData.toJson().toString());
        yield FacebookAuthLoggedInState();
      } catch (e) {
        yield FacebookAuthErrorState(message: e.toString());
      }
    }
    if (event is LogoutFacebookAuthEvent) {
      yield FacebookAuthLoadingState();
      try {
        SharedPreferences prefs =
        await SharedPreferences.getInstance();
        prefs.remove(USERDATA);
        yield FacebookAuthLoggedOutState();
      } catch (e) {
        yield FacebookAuthErrorState(message: e.toString());
      }
    }
  }

  dispose() {
    _facebookAuthController?.close();
  }
}
