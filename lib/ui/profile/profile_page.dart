import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mutuuze/bloc/authentication/user_bloc.dart';
import 'package:mutuuze/models/user_object.dart';
import 'package:mutuuze/ui/onboarding/register_login.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final userBloc = UserBloc();
  UserObject userData;

  @override
  void initState() {
    userBloc.loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pageSize = MediaQuery.of(context).size;

    return StreamBuilder<UserObject>(
      stream: userBloc.userStream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          if(snapshot.data.token != null){
            return Container(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          margin:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                          width: pageSize.width * 0.5,
                          height: pageSize.width * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(pageSize.width * 0.25),
                                topRight: Radius.circular(pageSize.width * 0.25),
                                topLeft: Radius.circular(pageSize.width * 0.25),
                                bottomRight: Radius.circular(pageSize.width * 0.25)),
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                              matchTextDirection: true,
                              image: NetworkImage(
                                  "https://www.ecolandproperty.com/wp-content/uploads/2020/06/Kololo-Residential-House-for-sale-2.jpeg"),
                              fit: BoxFit.cover,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Name: ',
                              style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                          TextSpan(text: 'John Doe', style: TextStyle(fontSize: 25.0))
                        ]),
                  ),
                  RichText(
                    softWrap: true,
                    text: TextSpan(style: TextStyle(color: Colors.black), children: <
                        TextSpan>[
                      TextSpan(
                          text: "Email: ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                      TextSpan(text: "frank@matatu.com", style: TextStyle(fontSize: 25))
                    ]),
                  ),
                  SizedBox(
                    height: 42.0,
                  ),
                  Text("For Assistance",
                      style: TextStyle(fontSize: 25, color: Color(0xFFff8000))),
                  Divider(
                    height: 15.0,
                    color: Color(0xFFff8000),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  RichText(
                    softWrap: true,
                    text: TextSpan(style: TextStyle(color: Colors.black), children: <
                        TextSpan>[
                      TextSpan(
                          text: "Call: ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                      TextSpan(text: "(256) 794654023", style: TextStyle(fontSize: 25))
                    ]),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RichText(
                    softWrap: true,
                    text: TextSpan(style: TextStyle(color: Colors.black), children: <
                        TextSpan>[
                      TextSpan(
                          text: "WhatsApp: ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                      TextSpan(text: "(256) 794654023", style: TextStyle(fontSize: 25))
                    ]),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RichText(
                    softWrap: true,
                    text: TextSpan(style: TextStyle(color: Colors.black), children: <
                        TextSpan>[
                      TextSpan(
                          text: "Email: ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                      TextSpan(text: "frank@matatu.com", style: TextStyle(fontSize: 25))
                    ]),
                  ),
                  SizedBox(
                    height: 42.0,
                  ),
                  RichText(
                    softWrap: true,
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: "App Version: ",
                          ),
                          TextSpan(text: "1.0.0")
                        ]),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 25.0,
                    width: double.infinity,
                    child: Text("\xA9 Mutuuze 2020"),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            );
          }
          else{
            return LoginRegister(false);
          }
        }
        return Container();
      }
    );
  }
}
