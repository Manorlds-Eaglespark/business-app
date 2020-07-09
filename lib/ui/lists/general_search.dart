import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mutuuze/bloc/favourites/favorites_bloc.dart';
import 'package:mutuuze/bloc/search/general_search_bloc.dart';
import 'package:mutuuze/models/property.dart';
import 'package:mutuuze/ui/lists/property_list.dart';
import 'package:progress_indicators/progress_indicators.dart';

class GeneralSearchPage extends StatefulWidget {
  final String searchQuery;

  GeneralSearchPage(this.searchQuery);

  @override
  _GeneralSearchPageState createState() => _GeneralSearchPageState();
}

class _GeneralSearchPageState extends State<GeneralSearchPage> {
  bool isSearching;
  final favBloc = FavouritesBloc();
  final searchBloc = GeneralSearchBloc();
  final _searchController = TextEditingController();
  List<Property> myFavs = [];

  @override
  void initState() {
    isSearching = true;
    favBloc.loadPropertyFavouritesDirect().then((v) {
      setState(() {
        myFavs = v;
      });
    });
    searchBloc.loadSearchResults(widget.searchQuery);
    super.initState();
  }

  makeASearch(String query) {
    if (query.length > 0) {
      searchBloc.loadSearchResults(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Search Results",
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            queryInputBox(),
            StreamBuilder(
              stream: searchBloc.getSearchResultsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                      child: PropertyList(snapshot.data, null, myFavs));
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget queryInputBox() {
    return Container(
      padding:
          EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Material(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(30.0)),
                elevation: 10.0,
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (v) => makeASearch(v),
                  keyboardType: TextInputType.multiline,
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15.0),
                    fillColor: Colors.transparent,
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(
                          color: Colors.transparent, width: 0.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    hintText: "      Search",
                  ),
                ),
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () => makeASearch(_searchController.text.toString()),
            elevation: 10.0,
            fillColor: Color(0xFFff8000),
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(7.0),
            shape: CircleBorder(),
          ),
        ],
      ),
    );
  }
}
