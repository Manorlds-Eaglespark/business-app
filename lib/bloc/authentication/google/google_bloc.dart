import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mutuuze/models/user_object.dart';
import 'package:mutuuze/resources/api_providers/onboarding/social_auth_api_provider.dart';
import 'package:mutuuze/resources/repositories/authentication/google_auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'google_events.dart';
import 'google_states.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {

  static const String USERDATA = "USERDATA";

  GoogleAuthRepository _repository = GoogleAuthRepository();
  SocialAuthApiProvider _socialAuthApiProvider = SocialAuthApiProvider();

  GoogleAuthBloc() : super(null);

  StreamController _googleAuthController = StreamController();

  StreamSink get googleAuthSink => _googleAuthController.sink;

  Stream get googleAuthStream => _googleAuthController.stream;

  @override
  GoogleAuthState get initialState => GoogleAuthInitialState();

  @override
  Stream<GoogleAuthState> mapEventToState(GoogleAuthEvent event) async* {
    if (event is LoginGoogleAuthEvent) {
      yield GoogleAuthLoadingState();
      try {
        String idToken = await _repository.login();
        UserObject userData =
            await _socialAuthApiProvider.fetchServerToken(idToken, 'google');
        SharedPreferences prefs =
            await SharedPreferences.getInstance();
        prefs.setString(USERDATA, userData.toJson().toString());

        yield GoogleAuthLoggedInState();
      } catch (e) {
        yield GoogleAuthErrorState(message: e.toString());
      }
    }
    if (event is LogoutGoogleAuthEvent) {
      yield GoogleAuthLoadingState();
      try {
        SharedPreferences prefs =
        await SharedPreferences.getInstance();
        prefs.remove(USERDATA);
        yield GoogleAuthLoggedOutState();
      } catch (e) {
        yield GoogleAuthErrorState(message: e.toString());
      }
    }
  }

  dispose() {
    _googleAuthController?.close();
  }
}
