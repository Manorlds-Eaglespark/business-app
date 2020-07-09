import 'package:flutter/material.dart';
import 'package:mutuuze/ui/home/home_page.dart';
import 'package:mutuuze/ui/onboarding/onboarding.dart';
import 'bloc/first_time_run/first_time.dart';
import 'bloc/manager/is_manager_check.dart';

void main() {
  runApp(MutuuzeApp());
}

class MutuuzeApp extends StatefulWidget {
  @override
  _MutuuzeAppState createState() => _MutuuzeAppState();
}

class _MutuuzeAppState extends State<MutuuzeApp> {
  final firstTimeBloc = FirstTimeBloc();
  final isManagerCheckBloc = IsManagerCheckBloc();

  @override
  void initState() {
    firstTimeBloc.loadUserFirstVisitStatus();
    super.initState();
  }

  void goToHomePage(BuildContext context){
    isManagerCheckBloc.getIsManagerStatusDirect().then((v){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  HomePage(v)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mutuuze',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<bool>(
          stream: firstTimeBloc.firstTimeStream,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.data == true){
                return OnBoardingScreen();
              }
              else{
                goToHomePage(context);
              }
            }
            return Container();
          }
      ),
    );
  }
}

