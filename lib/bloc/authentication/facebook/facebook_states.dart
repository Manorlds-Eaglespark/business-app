import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FacebookAuthState extends Equatable {}

class FacebookAuthInitialState extends FacebookAuthState {
  @override
  List<Object> get props => [];
}

class FacebookAuthLoadingState extends FacebookAuthState {
  @override
  List<Object> get props => [];
}

class FacebookAuthLoggedInState extends FacebookAuthState {
  @override
  List<Object> get props => [];
}

class FacebookAuthLoggedOutState extends FacebookAuthState {
  @override
  List<Object> get props => [];
}

class FacebookAuthErrorState extends FacebookAuthState {
  final String message;

  FacebookAuthErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
