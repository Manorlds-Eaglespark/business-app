
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mutuuze/bloc/authentication/facebook/facebook_bloc.dart';
import 'package:mutuuze/bloc/authentication/facebook/facebook_events.dart';
import 'package:mutuuze/bloc/authentication/facebook/facebook_states.dart';
import 'package:mutuuze/bloc/manager/is_manager_check.dart';
import 'package:mutuuze/ui/home/home_page.dart';
import 'package:mutuuze/ui/onboarding/register_login.dart';
import 'package:progress_indicators/progress_indicators.dart';

class FacebookButton extends StatefulWidget {
  final size;
  FacebookButton(this.size);
  @override
  _FacebookButtonState createState() => _FacebookButtonState();
}

class _FacebookButtonState extends State<FacebookButton> {
  var facebookAuthBloc;
  final isManagerCheckBloc = IsManagerCheckBloc();

  @override
  void dispose() {
    super.dispose();
    facebookAuthBloc.dispose();
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
    facebookAuthBloc = BlocProvider.of<FacebookAuthBloc>(context);
    return BlocBuilder<FacebookAuthBloc, FacebookAuthState>(
      builder: (context, state) {
        if (state is FacebookAuthLoggedInState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            goToHomePage();
          });
        }
        if (state is FacebookAuthLoadingState) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: JumpingDotsProgressIndicator(
              fontSize: 35.0,
              color: Colors.orange,
            ),
          );
        }
        if (state is FacebookAuthErrorState) {
          final snackBar = SnackBar(
            content: Text('Try a different Sign-in option.'),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scaffoldKey.currentState.showSnackBar(snackBar);
          });
        }

        return RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: widget.size.width*0.15, vertical: 10.0),
          onPressed: () => facebookAuthBloc.add(LoginFacebookAuthEvent()),
          color: Color(0xFF475993),
          child: SvgPicture.asset(
            'assets/images/facebook_icon.svg',
            semanticsLabel: 'Facebook',
            color: Colors.white,
            width: 25.0,
            height: 25.0,
          ),
        );
      },
    );
  }
}
