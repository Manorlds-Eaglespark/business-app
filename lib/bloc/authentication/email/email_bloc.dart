import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mutuuze/bloc/authentication/user_bloc.dart';
import 'package:mutuuze/bloc/manager/is_manager_check.dart';
import 'package:mutuuze/models/user_object.dart';
import 'package:mutuuze/resources/repositories/authentication/email_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'email_event.dart';
import 'email_state.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  EmailAuthRepository _repository = EmailAuthRepository();

  EmailAuthBloc() : super(null);

  StreamController _emailAuthController = StreamController();

  StreamSink get emailAuthSink => _emailAuthController.sink;

  Stream get emailAuthStream => _emailAuthController.stream;

  final userBloc = UserBloc();
  final isManagerCheckBloc = IsManagerCheckBloc();

  static const String USERDATA = "USERDATA";

  @override
  EmailAuthState get initialState => EmailAuthInitialState();

  @override
  Stream<EmailAuthState> mapEventToState(EmailAuthEvent event) async* {
    if (event is LoginEmailAuthEvent) {
      yield EmailAuthLoadingState();
      try {
        var userData = await _repository.loginUser(
            event.email, event.password, event.accountType);
        if (userData is UserObject) {
          userBloc.saveUserData(userData);

          userData.user.role == 0 ?
          isManagerCheckBloc.isManagerStatusSave(false)
              :isManagerCheckBloc.isManagerStatusSave(true);

          yield EmailAuthLoggedInState();
        } else {
          yield EmailAuthErrorState(message: userData);
        }
      } catch (e) {
        yield EmailAuthErrorState(message: e.toString());
      }
    }
    if (event is LogoutEmailAuthEvent) {
      yield EmailAuthLoadingState();
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove(USERDATA);
        yield EmailAuthLoggedOutState();
      } catch (e) {
        yield EmailAuthErrorState(message: e.toString());
      }
    }
  }

  dispose() {
    _emailAuthController?.close();
  }
}
