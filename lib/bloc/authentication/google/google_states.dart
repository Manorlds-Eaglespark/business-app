import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class GoogleAuthState extends Equatable {}

class GoogleAuthInitialState extends GoogleAuthState {
  @override
  List<Object> get props => [];
}

class GoogleAuthLoadingState extends GoogleAuthState {
  @override
  List<Object> get props => [];
}

class GoogleAuthLoggedInState extends GoogleAuthState {
  @override
  List<Object> get props => [];
}

class GoogleAuthLoggedOutState extends GoogleAuthState {
  @override
  List<Object> get props => [];
}

class GoogleAuthErrorState extends GoogleAuthState {
  final String message;

  GoogleAuthErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
