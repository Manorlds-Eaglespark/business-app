import 'package:flutter/material.dart';
import 'package:mutuuze/bloc/favourites/favorites_bloc.dart';
import 'package:mutuuze/bloc/property/property_bloc.dart';
import 'package:mutuuze/models/category.dart';
import 'package:mutuuze/models/property.dart';
import 'package:mutuuze/ui/lists/property_list.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'category_list_loader.dart';

class CategoryPropertyList extends StatefulWidget {
  final Category category;

  CategoryPropertyList(this.category);

  @override
  _CategoryPropertyListState createState() => _CategoryPropertyListState();
}

class _CategoryPropertyListState extends State<CategoryPropertyList> {
  final favBloc = FavouritesBloc();
  final propertyBloc = PropertyBloc();
  List<Property> myFavs = [];

  @override
  void initState() {
    super.initState();
    favBloc.loadPropertyFavouritesDirect().then((v){
      myFavs = v;
    });
    propertyBloc.loadPropertyByCategoryId(widget.category.id);
  }

  @override
  void dispose() {
    super.dispose();
    propertyBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("${widget.category.name}", style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
          stream: propertyBloc.propertyStream,
          builder: (context, snapshot){
            if(snapshot.hasData){
              List<Property> property = snapshot.data;
              return PropertyList(property == null ? [] : property, widget.category == null ? [] : widget.category, myFavs);
            }
            return Column(
              children: <Widget>[
                SizedBox(height: 30.0,),
                categoryListLoader(),
              ],
            );
          },
        ),
      ),
    );
  }
}
