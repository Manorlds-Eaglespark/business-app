import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mutuuze/bloc/authentication/email/email_bloc.dart';
import 'package:mutuuze/bloc/authentication/facebook/facebook_bloc.dart';
import 'package:mutuuze/bloc/authentication/google/google_bloc.dart';
import 'package:mutuuze/bloc/manager/is_manager_check.dart';
import 'package:mutuuze/ui/home/home_page.dart';

import 'email_form.dart';
import 'facebook_button.dart';
import 'google_button.dart';

class LoginRegister extends StatefulWidget {
  final bool isOnBoarding;

  LoginRegister(this.isOnBoarding);

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

final scaffoldKey = GlobalKey<ScaffoldState>();

class _LoginRegisterState extends State<LoginRegister> {
  bool isUserTypeSelected;
  int accountType;
  final isManagerCheckBloc = IsManagerCheckBloc();

  @override
  void initState() {
    isUserTypeSelected = false;
    super.initState();
  }

  void goToHomePage(){
    isManagerCheckBloc.getIsManagerStatusDirect().then((v){
          Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                HomePage(v)));
    });
  }

  void accountTypeSelected(int type) {
    type == 0
        ? isManagerCheckBloc.isManagerStatusSave(false)
        : isManagerCheckBloc.isManagerStatusSave(true);
    setState(() {
      accountType = type;
      isUserTypeSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      body: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
        child: isUserTypeSelected
            ? ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                children: <Widget>[
                  widget.isOnBoarding ? SizedBox(height: 16.0) : Container(),
                  widget.isOnBoarding
                      ? ButtonBar(
                          alignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.0),
                              ),
                              onPressed: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  goToHomePage();
                                });
                              },
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Text(
                          widget.isOnBoarding
                              ? "Get Started"
                              : "Register / Login",
                          style: TextStyle(fontSize: 25.0),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Please Register or Login to properly get started.",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 42.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: Center(
                        child: Text("Enter via Social Networks",
                            style: TextStyle(color: Colors.grey))),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BlocProvider<GoogleAuthBloc>(
                        create: (BuildContext context) => GoogleAuthBloc(),
                        child: Center(child: GoogleButton(size)),
                      ),
                      BlocProvider<FacebookAuthBloc>(
                        create: (BuildContext context) => FacebookAuthBloc(),
                        child: Center(child: FacebookButton(size)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 42.0,
                  ),
                  Center(child: Text("Or Register / Login with Email")),
                  SizedBox(
                    height: 15.0,
                  ),
                  BlocProvider<EmailAuthBloc>(
                    create: (BuildContext context) => EmailAuthBloc(),
                    child: Center(
                        child: EmailSignInForm(scaffoldKey, size, accountType)),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                ],
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 90.0,
                    ),
                    Text("Select", style: TextStyle(fontSize: 25.0)),
                    SizedBox(
                      height: 45.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => accountTypeSelected(0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 45.0,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Tenant / Buyer",
                                      style: TextStyle(fontSize: 16.5),
                                    ),
                                    Text(
                                      "e.g Rent / Buy / inquire about Property",
                                      style:
                                          TextStyle(color: Color(0xFF333333)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          FlatButton(
                            onPressed: () => accountTypeSelected(1),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Icon(
                                    Icons.supervised_user_circle,
                                    size: 45.0,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "LandLord / Manager",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "e.g Add / List property for clients",
                                      style:
                                          TextStyle(color: Color(0xFF333333)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
