import 'package:equatable/equatable.dart';

abstract class GoogleAuthEvent extends Equatable {}

class LoginGoogleAuthEvent extends GoogleAuthEvent {
  @override
  String toString() => 'GoogleLoginButtonPressed';

  @override
  List<Object> get props => null;
}

class LogoutGoogleAuthEvent extends GoogleAuthEvent {
  @override
  String toString() => 'GoogleLogoutButtonPressed';

  @override
  List<Object> get props => null;
}
