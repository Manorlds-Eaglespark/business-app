import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mutuuze/models/category.dart';

import 'category_property_list_page.dart';


Widget categoryCard(var size, Category category, BuildContext context){

  void openCategoryPropertyListPage(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CategoryPropertyList(category)));
  }

  List<Color> _colors = [Colors.transparent, Colors.grey];
  List<double> _stops = [0.0, 0.5];
  return GestureDetector(
    onTap: ()=>openCategoryPropertyListPage(),
    child: Card(
      elevation: 10.0,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.05),),
        margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: Stack(children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(
                        size.width * 0.05),),
                shape: BoxShape.rectangle,
                image: new DecorationImage(
                  matchTextDirection: true,
                  image: CachedNetworkImageProvider("${category.image}"),
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Container(
              width: size.width * 0.39,
              height: 35.0,
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.all(
                      Radius.circular(size.width * 0.05)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: _stops,
                    colors: _colors,
                  )),
            ),
          ),
          Positioned(
            child: Text(
              "${category.name}",
              softWrap: true,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            bottom: 10.0,
            left: 10.0,
          )
        ])),
  );
}
