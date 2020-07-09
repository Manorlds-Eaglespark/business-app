import 'package:equatable/equatable.dart';

abstract class FacebookAuthEvent extends Equatable{}

class LoginFacebookAuthEvent extends FacebookAuthEvent {
  @override
  String toString() => 'FacebookLoginButtonPressed';

  @override
  List<Object> get props => null;
}

class LogoutFacebookAuthEvent extends FacebookAuthEvent {

  @override
  String toString() => 'FacebookLogoutButtonPressed';

  @override
  List<Object> get props => null;
}