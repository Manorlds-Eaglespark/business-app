import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mutuuze/models/property.dart';
import 'package:mutuuze/ui/details/property_details.dart';
import 'package:mutuuze/ui/profile/profile_page.dart';
import 'package:progress_indicators/progress_indicators.dart';

class HomePageDetail extends StatefulWidget {
  @override
  _HomePageDetailState createState() => _HomePageDetailState();
}

class _HomePageDetailState extends State<HomePageDetail> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<Color> _colors = [Colors.transparent, Colors.grey];
    List<double> _stops = [0.0, 0.8];
    return ListView(
      children: <Widget>[
        firstProperty(size, _colors, _stops),
        SizedBox(
          height: 15.0,
        ),
        Container(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Popular",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            )),
        popularLineUp(context),
        SizedBox(
          height: 15.0,
        ),
        Container(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Recommended",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            )),
        recommendedProperty(size),
      ],
    );
  }
}

Widget firstProperty(var size, var _colors, var _stops) {
  return Container(
    height: size.height * 0.6,
    child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (BuildContext context, int position) {
          return Stack(children: <Widget>[
            Container(
                width: size.width * 0.6,
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.elliptical(size.width * 0.1, size.width * 0.1),
                      topLeft: Radius.circular(size.width * 0.1),
                      bottomRight: Radius.circular(size.width * 0.1)),
                  shape: BoxShape.rectangle,
                  image: new DecorationImage(
                    matchTextDirection: true,
                    image: CachedNetworkImageProvider(
                        "https://www.ecolandproperty.com/wp-content/uploads/2020/06/Kololo-Residential-House-for-sale-2.jpeg"),
                    fit: BoxFit.fitHeight,
                  ),
                )),
            Positioned(
              left: 20.0,
              bottom: 40.0,
              child: Container(
                width: size.width * 0.57,
                height: 75.0,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(size.width * 0.1)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: _stops,
                      colors: _colors,
                    )),
              ),
            ),
            Positioned(
                left: 40.0,
                bottom: 50.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "\$ 4,850,000",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text("Bristol England",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                )),
          ]);
        }),
  );
}

Widget popularLineUp(BuildContext context) {

  var Propty = Property.fromJson(  {
    "address": "Kulambiro Stage",
    "agent_id": 3,
    "amenities": [],
    "category_id": 7,
    "description": "Gated Self contained rooms in a good neighborhood. You are welcome!",
    "id": 19,
    "lat": 0.0,
    "long": 0.0,
    "name": "Kulambilo Cotttages",
    "photos": [],
    "price_offer": "UGX 220,000",
    "time_added": "2020-07-13 06:54:26.892943"
  });
  void navigateToDetailsPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PropertyDetails(Propty, null, false)));
  }

  return GridView.count(
    scrollDirection: Axis.vertical,
    physics: ScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: 15.0),
    shrinkWrap: true,
    crossAxisCount: 2,
    children: List.generate(4, (index) {
      return Center(
          child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () => navigateToDetailsPage(),
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: CachedNetworkImage(imageUrl: "https://www.ecolandproperty.com/wp-content/uploads/2020/06/Kololo-Residential-House-for-sale-2.jpeg",
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
                    onPressed: () {},
                    elevation: 0.0,
                    child: Icon(
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
              onTap: () => navigateToDetailsPage(),
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
    }),
  );
}

Widget recommendedProperty(size) {
  return Container(
      width: size.width,
      height: size.height * 0.4,
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(size.width * 0.1),
            topLeft: Radius.circular(size.width * 0.1),
            topRight: Radius.circular(size.width * 0.1),
            bottomRight: Radius.circular(size.width * 0.1)),
        shape: BoxShape.rectangle,
        image: new DecorationImage(
          matchTextDirection: true,
          image: CachedNetworkImageProvider(
              "https://www.ecolandproperty.com/wp-content/uploads/2020/06/Kololo-Residential-House-for-sale-2.jpeg"),
          fit: BoxFit.cover,
        ),
      ));
}
