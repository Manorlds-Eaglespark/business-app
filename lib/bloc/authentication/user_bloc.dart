import 'dart:convert';

import 'package:mutuuze/models/user_object.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc {
  final _thisUser = BehaviorSubject<UserObject>();
  static const String USERDATA = "USERDATA";

  //Getters
  Stream<UserObject> get userStream => _thisUser.stream;

  //Setters
  Function(UserObject) get changeUser => _thisUser.sink.add;

  void saveUserData(UserObject userObject) async {
    if (_isDisposed) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var alreadySavedUser = prefs.getString(USERDATA);
    if (alreadySavedUser != null) {
      prefs.remove(USERDATA);
    }
    prefs.setString(USERDATA, jsonEncode(userObject.toJson()));
  }

  void logoutUser() async {
    if (_isDisposed) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(USERDATA);
  }

  loadUserData() async {
    if (_isDisposed) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userData = prefs.getString(USERDATA);
    if (userData == null) {
      changeUser(UserObject());
    } else {
      changeUser(UserObject.fromJson(jsonDecode(userData)));
    }
  }

  loadUserDataDirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString(USERDATA);
    if (userData == null) {
      return;
    } else {
      print(UserObject.fromJson(jsonDecode(userData)));
      return UserObject.fromJson(jsonDecode(userData));
    }
  }

  bool _isDisposed = false;

  dispose() {
    _thisUser.close();
    _isDisposed = true;
  }
}
