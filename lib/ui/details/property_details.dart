import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mutuuze/bloc/favourites/favorites_bloc.dart';
import 'package:mutuuze/models/category.dart';
import 'package:mutuuze/models/property.dart';
import 'package:mutuuze/resources/utilities/time_converter.dart';

class PropertyDetails extends StatefulWidget {
  final Category category;
  final Property property;
  final bool isFavourite;
  PropertyDetails(this.property, this.category, this.isFavourite);

  @override
  _PropertyDetailsState createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  int currentImage;
  bool isFavourite;
  bool showNextImageButton;
  bool showPreviousImageButton;
  final favouritesBloc = FavouritesBloc();

  @override
  void initState() {
    super.initState();
    showNextImageButton = false;
    showPreviousImageButton = false;
    if(widget.property.photos.isNotEmpty){
      currentImage = 0;
      if(widget.property.photos != null || widget.property.photos.isNotEmpty) {
        if (widget.property.photos.length > 1) {
          setState(() {
            showNextImageButton = true;
            showPreviousImageButton = false;
          });
        }
        else {
          setState(() {
            showNextImageButton = false;
            showPreviousImageButton = false;
          });
        }
      }else{
        setState(() {
          showNextImageButton = false;
          showPreviousImageButton = false;
        });
      }
    }
    isFavourite = widget.isFavourite;
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

  void showNextPicture(){
    int max = widget.property.photos.length - 1;
    if(currentImage < max){
      setState(() {
        currentImage += 1;
        showPreviousImageButton = true;
      });
    }
    if(currentImage == max){
      setState(() {
        showNextImageButton = false;
      });
    }
  }

  void showPreviousPicture(){
    int max = widget.property.photos.length - 1;
    if(currentImage > 0){
      setState(() {
        currentImage -= 1;
        showNextImageButton = true;
      });
    }
    if(currentImage == 0){
      setState(() {
        showPreviousImageButton = false;
        showNextImageButton = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(elevation: 0.0,
        iconTheme: IconThemeData(color: Color(0xff333333)),
        title: Text(
          "Property Details",
          style: TextStyle(color: Color(0xff333333)),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(color: Colors.white,
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: size.width,
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.width * 0.1)),
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                      matchTextDirection: true,
                      image: CachedNetworkImageProvider(
                          widget.property.photos.isEmpty ?
                          "https://www.ecolandproperty.com/wp-content/uploads/2020/06/Kololo-Residential-House-for-sale-2.jpeg"
                      : widget.property.photos[currentImage].image),
                      fit: BoxFit.fill,
                    ),
                  )),

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

                Positioned(
                  right: 10.0,
                  top: size.height * 0.15,
                  child: showNextImageButton ? MaterialButton(
                    color: Colors.white,
                    height: 20.0,
                    minWidth: 10.0,
                    onPressed: ()=>showNextPicture(),
                    elevation: 0.0,
                    child: Icon(
                      Icons.arrow_forward,
                      size: 20.0,
                      color: Color(0xFFff8000),
                    ),
                    padding: EdgeInsets.all(2.5),
                    shape: CircleBorder(),
                  ): Container(),
                ),



                Positioned(
                  left: 10.0,
                  top: size.height * 0.15,
                  child: showPreviousImageButton ? MaterialButton(
                    color: Colors.white,
                    height: 20.0,
                    minWidth: 10.0,
                    onPressed: ()=>showPreviousPicture(),
                    elevation: 0.0,
                    child: Icon(
                      Icons.arrow_back,
                      size: 20.0,
                      color: Color(0xFFff8000),
                    ),
                    padding: EdgeInsets.all(2.5),
                    shape: CircleBorder(),
                  ) : Container(),
                ),

                Positioned(
                  top: size.height * 0.35,
                  child: Container(
                    width: size.width,
                    height: size.height * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(size.width * 0.1)),
                      )
                  ),
                ),
        ]
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.property.timeAdded == null ? Container() :Text("Posted ${Jiffy(DateTime.parse(ConvertTimeToLocal().getCurrentLocalTime(widget.property.timeAdded))).fromNow()}"),
                SizedBox(width: 15.0,)
              ],
            ),


            Container(
                padding: EdgeInsets.only(left: 35.0),
                child: Text(
                  "${widget.property.priceOffer}",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFff8000)),
                )),
            Container(
              padding: EdgeInsets.only(left: 35.0, top: 15.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 15.0,
                  ),
                  Text("${widget.property.address}",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 35.0, top: 15.0),
              child: Text(
                "${widget.property.name}",
                style: TextStyle(
                    fontSize: 20.0,),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 35.0, top: 15.0),
              child: Text(
                widget.category == null ? " " : "${widget.category.name}",
                style: TextStyle(fontSize: 18.0, color: Color(0xFFff8000)),
              ),
            ),
            SizedBox(height: 15.0,),
            Container(
              padding: EdgeInsets.only(left: 35.0, top: 15.0),
              child: Row(
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
            ),
            Container(
                padding: EdgeInsets.only(left: 35.0, right: 35.0, top: 15.0),
                child: Text("${widget.property.description}")),
            Container(
              padding: EdgeInsets.only(left: 35.0, top: 30.0),
              child: Text(
                "Amenities",
                style: TextStyle(fontSize: 18.0, color: Color(0xFFff8000)),
              ),
            ),
            amenities(),
            Container(
              padding: EdgeInsets.only(left: 35.0, top: 15.0, right: 35.0),
              child: Image.asset("assets/images/map.png"),
            ),
            actionButtons(size),
          ],
        ),
      ),
    );
  }
}

Widget amenities() {
  return Container(
    padding: EdgeInsets.only(left: 35.0),
    width: double.infinity,
    height: 70.0,
    child: ListView(
      physics: ScrollPhysics(),
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[Icon(Icons.wifi), Text("WIFI")],
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[Icon(Icons.location_on), Text("Shops")],
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[Icon(Icons.map), Text("ROAD")],
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[Icon(Icons.atm), Text("ATM")],
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[Icon(Icons.kitchen), Text("Kitchen")],
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[Icon(Icons.ac_unit), Text("AC")],
            ),
          ),
        )
      ],
    ),
  );
}





Widget actionButtons(size){
  return
    Container(
      padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: size.width * 0.4,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Color(0xffffcb96),
              borderRadius: BorderRadius.only(
                  bottomLeft:
                  Radius.circular(size.width * 0.1),
                  topLeft: Radius.circular(size.width * 0.1),
                  bottomRight: Radius.circular(size.width * 0.1)),
              shape: BoxShape.rectangle,
            ),
            child: Center(child: Text("Ask a Question")),
          ),
          Container(
            width: size.width * 0.4,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Color(0xFFff8000),
              borderRadius: BorderRadius.only(
                  bottomLeft:
                  Radius.circular(size.width * 0.1),
                  topLeft: Radius.circular(size.width * 0.1),
                  bottomRight: Radius.circular(size.width * 0.1)),
              shape: BoxShape.rectangle,
            ),
            child: Center(child: Text("Express Interest", style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
}