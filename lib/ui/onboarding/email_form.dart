import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mutuuze/bloc/authentication/email/email_bloc.dart';
import 'package:mutuuze/bloc/authentication/email/email_event.dart';
import 'package:mutuuze/bloc/authentication/email/email_state.dart';
import 'package:mutuuze/bloc/manager/is_manager_check.dart';
import 'package:mutuuze/ui/home/home_page.dart';
import 'package:progress_indicators/progress_indicators.dart';

class EmailSignInForm extends StatefulWidget {
  final scaffoldKey;
  final size;
  final int accountType;

  EmailSignInForm(this.scaffoldKey, this.size, this.accountType);

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  var _formKey;
  var emailAuthBloc;
  final isManagerCheckBloc = IsManagerCheckBloc();

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
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
  void dispose() {
    super.dispose();
    emailAuthBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    emailAuthBloc = BlocProvider.of<EmailAuthBloc>(context);
    return BlocBuilder<EmailAuthBloc, EmailAuthState>(
      builder: (context, state) {
        if (state is EmailAuthLoggedInState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            goToHomePage();
          });
        }
        if (state is EmailAuthLoadingState) {
          return JumpingDotsProgressIndicator(
            fontSize: 40.0,
            color: Colors.orange,
          );
        }
        if (state is EmailAuthErrorState) {
          final snackBar = SnackBar(
            content: Text('Error: ' + state.toString()),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.scaffoldKey.currentState.showSnackBar(snackBar);
          });
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: new InputDecoration(
                      labelText: "E-mail Address",
                      errorStyle: TextStyle(color: Colors.orange),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Error | Email required";
                    }
                    Pattern pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(val)) {
                      return "Error | Use a valid Email";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Error | Password required";
                    }
                    if (val.length <= 3) {
                      return "Error | Use stronger password.";
                    } else {
                      return null;
                    }
                  },
                  decoration: new InputDecoration(
                      labelText: "Password",
                      errorStyle: TextStyle(color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                  child: Container(
                    width:size.width,
                    child: Center(
                      child: Text(
                        'Finish',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  color: Color(0xffff8000),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      emailAuthBloc.add(LoginEmailAuthEvent(
                          email: _emailController.text,
                          password: _passwordController.text,
                      accountType: widget.accountType));
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
