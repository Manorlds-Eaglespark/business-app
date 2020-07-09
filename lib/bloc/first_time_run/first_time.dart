import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeBloc {
  final _checkVisit = BehaviorSubject<bool>();
  static const String FIRSTTIME = "FIRSTTIME";

  //Getters
  Stream<bool> get firstTimeStream => _checkVisit.stream;

  //Setters
  Function(bool) get changeVisitStatus => _checkVisit.sink.add;

  loadUserFirstVisitStatus() async {
    if (_isDisposed) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userVisit = prefs.getBool(FIRSTTIME);
    if (userVisit == null) {
      prefs.setBool(FIRSTTIME, false);
      changeVisitStatus(true);
    } else {
      return userVisit == true ? changeVisitStatus(true) : changeVisitStatus(false);
    }
  }


  bool _isDisposed = false;

  dispose() {
    _checkVisit.close();
    _isDisposed = true;
  }
}
