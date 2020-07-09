import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsManagerCheckBloc {
  final _isManagerCheck = BehaviorSubject<bool>();
  static const String ISMANAGER = "ISMANAGER";

  //Getters
  Stream<bool> get userStream => _isManagerCheck.stream;

  //Setters
  Function(bool) get changeManagerStatus => _isManagerCheck.sink.add;

  void isManagerStatusSave(bool status) async {
    if (_isDisposed) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var getIsManagerStatus = prefs.getBool(ISMANAGER);
    if (getIsManagerStatus != null) {
      prefs.remove(ISMANAGER);
    }
    prefs.setBool(ISMANAGER, status);
  }

  getIsManagerStatus() async {
    if (_isDisposed) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isManagerStatus = prefs.getBool(ISMANAGER);
    if (isManagerStatus == null) {
      isManagerStatusSave(false);
      changeManagerStatus(false);
    } else {
      changeManagerStatus(isManagerStatus);
    }
  }

  getIsManagerStatusDirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isManagerStatus = prefs.getBool(ISMANAGER);
    if (isManagerStatus == null) {
      isManagerStatusSave(false);
      return false;
    } else {
      return isManagerStatus;
    }
  }

  bool _isDisposed = false;

  dispose() {
    _isManagerCheck.close();
    _isDisposed = true;
  }
}
