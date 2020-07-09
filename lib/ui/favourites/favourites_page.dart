import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mutuuze/bloc/favourites/favorites_bloc.dart';
import 'package:mutuuze/models/property.dart';

import 'favourite_property_card.dart';

class FavouriteProperty extends StatefulWidget {
  @override
  _FavouritePropertyState createState() => _FavouritePropertyState();
}

class _FavouritePropertyState extends State<FavouriteProperty> {

  final favouritesBloc = FavouritesBloc();

  @override
  void initState() {
    super.initState();
    favouritesBloc.loadPropertyFavourites();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: StreamBuilder<List<Property>>(
        stream: favouritesBloc.propertyFavouritesStream,
        builder: (context, snapshot)
    {
      if(snapshot.hasData){
        var favouriteProperty = snapshot.data;
        if(favouriteProperty.isEmpty){
          return Container(child: Center(child: Text("You have not favourited any property yet."),),);
        }
      return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(right: 15.0, left: 15.0),
        child: ListView.separated(
          separatorBuilder: (context, index) =>
              Divider(
                color: Color(0xFF333333), height: 2.0,
              ),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: favouriteProperty.length,
          itemBuilder: (context, index) {
            return FavouritePropertyCard(size, favouriteProperty[index]);
          },
        ),
      );
    }
      else{
        return Container();
      }
        }
      ),
    );
  }
}
