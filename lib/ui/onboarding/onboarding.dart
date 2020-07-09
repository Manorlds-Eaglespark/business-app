import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mutuuze/ui/home/home_page.dart';
import 'package:mutuuze/ui/onboarding/register_login.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'onboarding_2.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  void navigateToNextScreen() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => OnboardingScreenTwo()));
  }

  void navigateSkip() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => LoginRegister(true)));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "SKIP",
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0),
                  ),
                  onPressed: ()=>navigateSkip(),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/info_image_1.png",
                  width: size.width * 0.9,
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: LinearPercentIndicator(
                    width: size.width * 0.7,
                    lineHeight: 8.0,
                    percent: 0.33,
                    progressColor: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
              width: size.width * 0.7,
              child: Text(
                  """The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also"""),
            ),
            SizedBox(
              height: 42.0,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 42.0),
                  color: Colors.white,
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0),
                  ),
                  onPressed: () => navigateToNextScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
