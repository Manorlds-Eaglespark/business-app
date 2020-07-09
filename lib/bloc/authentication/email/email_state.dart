import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class EmailAuthState extends Equatable {}

class EmailAuthInitialState extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class EmailAuthLoadingState extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class EmailAuthLoggedInState extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class EmailAuthLoggedOutState extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class EmailAuthErrorState extends EmailAuthState {
  final String message;

  EmailAuthErrorState({@required this.message});

  @override
  String toString() {
    return this.message;
  }

  @override
  List<Object> get props => [message];
}
