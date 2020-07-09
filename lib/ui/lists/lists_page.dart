import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mutuuze/bloc/categories/all_categories.dart';
import 'package:mutuuze/models/category.dart';
import 'package:mutuuze/ui/lists/general_search.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'category_card.dart';
import 'category_list_loader.dart';

class PropertyListPage extends StatefulWidget {
  @override
  _PropertyListPageState createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  final allCategoriesBloc = AllCategoriesBloc();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allCategoriesBloc.loadAllCategories();
  }

  @override
  void dispose() {
    allCategoriesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    getCategoriesWidgets(List<Category> categories) {
      return categories.map<Widget>((e) => categoryCard(size, e, context)).toList();
    }

    return Container(
        child: Column(
      children: <Widget>[

        queryInputBox(_searchController, size, context),

        StreamBuilder<List<Category>>(
            stream: allCategoriesBloc.getAllCategoriesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Category> categories = snapshot.data;
                return Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    shrinkWrap: true,
                    children: getCategoriesWidgets(categories),
                  ),
                );
              }
              return categoryListLoader();

            }),
      ],
    ));
  }
}













Widget queryInputBox(_searchController, size, context) {

  goToSearchPage(String query){
    if(query.length > 0){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> GeneralSearchPage(query)));
    }
  }

  return Container(
    padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
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
                onSubmitted: (v)=>goToSearchPage(v),
                keyboardType: TextInputType.multiline,
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15.0),
                  fillColor: Colors.transparent,
                  enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
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
          onPressed: ()=>goToSearchPage(_searchController.text.toString()),
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