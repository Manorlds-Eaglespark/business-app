import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mutuuze/models/category.dart';
import 'package:mutuuze/models/property.dart';
import 'package:mutuuze/ui/lists/property_list_card.dart';

class PropertyList extends StatefulWidget {
  final List<Property> property;
  final List<Property> favouritesList;
  final Category category;

  PropertyList(this.property, this.category, this.favouritesList);

  @override
  _PropertyListState createState() => _PropertyListState();
}

class _PropertyListState extends State<PropertyList> {

  @override
  void initState() {
    super.initState();
  }


  List<Widget> getPropertyCardWidgets(
      List<Property> property) {
    return property
        .map<Widget>(
            (e) => PropertyListCard(e, widget.category, widget.favouritesList.contains(e)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return widget.property.isEmpty
        ? Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text("None found now. Hopefully check again later."),
            ),
          )
        : Container(
      height: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: GridView.count(
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: getPropertyCardWidgets(widget.property),
                    ),
                  ),
              ),
            ],
          ),
        );
  }
}
















