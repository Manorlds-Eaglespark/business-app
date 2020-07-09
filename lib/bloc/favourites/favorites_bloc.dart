import 'dart:convert';
import 'package:mutuuze/models/property.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesBloc {
  final _allFavourites = BehaviorSubject<List<Property>>();
  static const String FAVOURITES = "FAVOURITES";

  //Getters
  Stream<List<Property>> get propertyFavouritesStream => _allFavourites.stream;

  //Setters
  Function(List<Property>) get changePropertyFavourites =>
      _allFavourites.sink.add;

  void savePropertyFavourite(Property property) async {
    if(_isDisposed){
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var alreadySavedFavourites = prefs.getString(FAVOURITES);
    var newFavourites = [];
    if (alreadySavedFavourites != null) {
      newFavourites = jsonDecode(alreadySavedFavourites);
    }
    newFavourites.toSet().toList();
    newFavourites.add(jsonEncode(property.toJson()));
    await prefs.setString(FAVOURITES, jsonEncode(newFavourites));
  }

  void removeFavouriteProperty(Property property) async{
    if(_isDisposed){
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List favourites = jsonDecode(prefs.getString(FAVOURITES)) as List;
    favourites.removeWhere((item) => Property.fromJson(jsonDecode(item)) == property);
    await prefs.remove(FAVOURITES);
    await prefs.setString(FAVOURITES, jsonEncode(favourites));
  }

  loadPropertyFavourites() async {
    if(_isDisposed){
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString(FAVOURITES) != null){
      List favourites = jsonDecode(prefs.getString(FAVOURITES)) as List;
      changePropertyFavourites(favourites.map<Property>((e) => Property.fromJson(jsonDecode(e))).toList());
    }
    else{
      changePropertyFavourites([]);
    }
     }

  loadPropertyFavouritesDirect() async {
    if(_isDisposed){
      return;
    }
    List<Property> propty = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString(FAVOURITES) != null) {
      List favourites = jsonDecode(prefs.getString(FAVOURITES)) as List;
      return favourites.map<Property>((e) => Property.fromJson(jsonDecode(e)))
          .toList();
    }else{
      return propty;
    }
  }


  bool _isDisposed = false;
  dispose() {
    _allFavourites.close();
    _isDisposed = true;
  }
}
