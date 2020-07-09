
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mutuuze/bloc/authentication/google/google_bloc.dart';
import 'package:mutuuze/bloc/authentication/google/google_events.dart';
import 'package:mutuuze/bloc/authentication/google/google_states.dart';
import 'package:mutuuze/bloc/manager/is_manager_check.dart';
import 'package:mutuuze/ui/home/home_page.dart';
import 'package:mutuuze/ui/onboarding/register_login.dart';
import 'package:progress_indicators/progress_indicators.dart';

class GoogleButton extends StatefulWidget {
  final size;
  GoogleButton(this.size, );
  @override
  _GoogleButtonState createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  var googleAuthBloc;
  final isManagerCheckBloc = IsManagerCheckBloc();

  @override
  void dispose() {
    super.dispose();
    googleAuthBloc.dispose();
  }

  void goToHomePage(){
    isManagerCheckBloc.getIsManagerStatusDirect().then((v){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  HomePage(v)));
    });
  }

  @override
  Widget build(BuildContext context) {
    googleAuthBloc = BlocProvider.of<GoogleAuthBloc>(context);
    return BlocBuilder<GoogleAuthBloc, GoogleAuthState>(
      builder: (context, state) {
        if (state is GoogleAuthLoggedInState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            goToHomePage();
          });
        }
        if (state is GoogleAuthLoadingState) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: JumpingDotsProgressIndicator(
              fontSize: 35.0,
              color: Colors.orange,
            ),
          );
        }
        if (state is GoogleAuthErrorState) {
          final snackBar = SnackBar(
            content: Text('Try a different Sign-in option.'),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scaffoldKey.currentState.showSnackBar(snackBar);
          });
        }

        return RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: widget.size.width*0.15, vertical: 10.0),
          onPressed: () => googleAuthBloc.add(LoginGoogleAuthEvent()),
          color: Colors.white,
          child: SvgPicture.asset(
            'assets/images/google.svg',
            semanticsLabel: 'Google',
            width: 25.0,
            height: 25.0,
          ),
        );
      },
    );
  }
}