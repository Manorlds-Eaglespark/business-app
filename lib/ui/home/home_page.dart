import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mutuuze/ui/favourites/favourites_page.dart';
import 'package:mutuuze/ui/home/home_page_detail.dart';
import 'package:mutuuze/ui/lists/lists_page.dart';
import 'package:mutuuze/ui/manager_property/manager_property_page.dart';
import 'package:mutuuze/ui/profile/profile_page.dart';

class HomePage extends StatefulWidget {

  final bool isManager;
  HomePage(this.isManager);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    List<Widget> tabs = [
      HomePageDetail(),
      PropertyListPage(),
      widget.isManager ? ManagerProperty() : FavouriteProperty(),
      UserProfilePage()
    ];


    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          leading: Container(),
          title: Row(
            children: <Widget>[
              Image.asset("assets/images/mutuuze.png", height: 36.0,),
              SizedBox(width: 5.0,),
              Text(
                "Mutuuze",
                style: TextStyle(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          iconSize: 25.0,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text('Listing'),
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
              icon: Icon(widget.isManager ? Icons.star_border :Icons.favorite_border),
              title: widget.isManager ? Text("Listed") : Text("Favourites"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text("Account"),
            )
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        backgroundColor: Colors.white,
        body: tabs[_currentIndex]);
  }
}
