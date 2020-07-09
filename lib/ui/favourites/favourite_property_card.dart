import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mutuuze/models/property.dart';
import 'package:mutuuze/ui/details/property_details.dart';

class FavouritePropertyCard extends StatefulWidget {
  final pageSize;
  final Property property;

  FavouritePropertyCard(this.pageSize, this.property);

  @override
  _FavouritePropertyCardState createState() => _FavouritePropertyCardState();
}

class _FavouritePropertyCardState extends State<FavouritePropertyCard> {
  void navigateToDetailsPage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PropertyDetails(widget.property, null, true)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => navigateToDetailsPage(),
      child: Container(
        padding: const EdgeInsets.only(top: 30.0),
        child: Row(
          children: <Widget>[
            Container(
                height: widget.pageSize.height * 0.15,
                width: widget.pageSize.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(widget.pageSize.width * 0.025),
                      topRight: Radius.circular(widget.pageSize.width * 0.025),
                      topLeft: Radius.circular(widget.pageSize.width * 0.025),
                      bottomRight:
                          Radius.circular(widget.pageSize.width * 0.025)),
                  shape: BoxShape.rectangle,
                  image: new DecorationImage(
                    matchTextDirection: true,
                    image: CachedNetworkImageProvider(widget
                            .property.photos.isEmpty
                        ? "https://www.ecolandproperty.com/wp-content/uploads/2020/06/Kololo-Residential-House-for-sale-2.jpeg"
                        : widget.property.photos[0].image),
                    fit: BoxFit.cover,
                  ),
                )),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 7.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget.property.priceOffer}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    Text("${widget.property.address}"),
                    SizedBox(
                      height: 7.5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          "1,200 sq.ft",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
