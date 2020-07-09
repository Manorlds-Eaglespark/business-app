import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mutuuze/bloc/favourites/favorites_bloc.dart';
import 'package:mutuuze/models/category.dart';
import 'package:mutuuze/models/property.dart';
import 'package:mutuuze/ui/details/property_details.dart';
import 'package:progress_indicators/progress_indicators.dart';

class PropertyListCard extends StatefulWidget {
  final Property property;
  final Category category;
  final bool isFavourite;
  PropertyListCard(this.property, this.category, this.isFavourite);

  @override
  _PropertyListCardState createState() => _PropertyListCardState();
}

class _PropertyListCardState extends State<PropertyListCard> {

  final favouritesBloc = FavouritesBloc();
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.isFavourite;
  }

  void navigateToDetailsPage(Property property) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PropertyDetails(widget.property, widget.category, isFavourite)));
  }

  void saveFavourite(){
    if(isFavourite){
      favouritesBloc.removeFavouriteProperty(widget.property);
    }else{
      favouritesBloc.savePropertyFavourite(widget.property);
    }
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 7.5, vertical: 7.5),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => navigateToDetailsPage(widget.property),
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.property.photos.isEmpty ?
                        "https://www.ecolandproperty.com/wp-content/uploads/2020/06/Kololo-Residential-House-for-sale-2.jpeg"
                            : widget.property.photos[0].image,
                        placeholder: (context, url) => Center(
                          child: JumpingDotsProgressIndicator(
                            fontSize: 35.0,
                            color: Colors.orange,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10.0,
                    top: 10.0,
                    child: MaterialButton(
                      color: Colors.white,
                      height: 20.0,
                      minWidth: 10.0,
                      onPressed: ()=>saveFavourite(),
                      elevation: 0.0,
                      child: isFavourite ? Icon(
                        Icons.favorite,
                        size: 20.0,
                        color: Color(0xFFff8000),
                      ):Icon(
                        Icons.favorite_border,
                        size: 20.0,
                        color: Color(0xFFff8000),
                      ),
                      padding: EdgeInsets.all(2.5),
                      shape: CircleBorder(),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => navigateToDetailsPage(widget.property),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/icons/bath.svg',
                          height: 15.0,
                          allowDrawingOutsideViewBox: false,
                          semanticsLabel: 'Bedrooms',
                          color: Color(0xff333333),
                        ),
                        SizedBox(
                          width: 3.75,
                        ),
                        Text("2"),
                        SizedBox(
                          width: 7.5,
                        ),
                        SvgPicture.asset(
                          'assets/icons/double_bed.svg',
                          height: 15.0,
                          allowDrawingOutsideViewBox: false,
                          semanticsLabel: 'Bedrooms',
                          color: Color(0xff333333),
                        ),
                        SizedBox(
                          width: 3.75,
                        ),
                        Text("3"),
                      ],
                    ),
                    Text("1,200 sq.ft"),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
