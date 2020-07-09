import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class EmailAuthEvent extends Equatable {}

class LoginEmailAuthEvent extends EmailAuthEvent {
  final String email;
  final String password;
  final int accountType;

  LoginEmailAuthEvent({@required this.email, @required this.password, @required this.accountType});

  @override
  String toString() => 'EmailLoginButtonPressed';

  @override
  List<Object> get props => [email, password, accountType];
}

class LogoutEmailAuthEvent extends EmailAuthEvent {
  @override
  String toString() => 'EmailLogoutButtonPressed';

  @override
  List<Object> get props => null;
}
