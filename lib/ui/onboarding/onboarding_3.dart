import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mutuuze/ui/onboarding/register_login.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class OnboardingScreenThree extends StatefulWidget {
  @override
  _OnboardingScreenThreeState createState() => _OnboardingScreenThreeState();
}

class _OnboardingScreenThreeState extends State<OnboardingScreenThree> {
  void navigateToLoginPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginRegister(true)));
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
            SizedBox(height: 30.0),
            SizedBox(
              height: 30.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/info_image_3.png",
                  width: size.width * 0.9,
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: LinearPercentIndicator(
                    width: size.width * 0.7,
                    lineHeight: 8.0,
                    percent: 1,
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
            Center(
              child: Container(
                width: size.width * 0.8,
                child: ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 35.0),
                      color: Colors.white,
                      child: Text(
                        "BACK",
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 35.0),
                      color: Colors.white,
                      child: Text(
                        "GET STARTED",
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0),
                      ),
                      onPressed: () => navigateToLoginPage(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
