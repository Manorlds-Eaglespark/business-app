import 'package:mutuuze/models/amenities.dart';
import 'package:mutuuze/models/photos.dart';

class Property {
  String address;
  int agentId;
  List<Amenities> amenities;
  int categoryId;
  String description;
  int id;
  double lat;
  double long;
  String name;
  List<Photo> photos;
  String priceOffer;
  String timeAdded;

  Property(
      {this.address,
        this.agentId,
        this.amenities,
        this.categoryId,
        this.description,
        this.id,
        this.lat,
        this.long,
        this.name,
        this.photos,
        this.priceOffer,
        this.timeAdded});

  Property.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    agentId = json['agent_id'];
    if (json['amenities'] != null) {
      amenities = new List<Null>();
      json['amenities'].forEach((v) {
        amenities.add(new Amenities.fromJson(v));
      });
    }
    categoryId = json['category_id'];
    description = json['description'];
    id = json['id'];
    lat = json['lat'];
    long = json['long'];
    name = json['name'];
    if (json['photos'] != null) {
      photos = new List<Photo>();
      json['photos'].forEach((v) {
        photos.add(new Photo.fromJson(v));
      });
    }
    priceOffer = json['price_offer'];
    timeAdded = json['time_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['agent_id'] = this.agentId;
    if (this.amenities != null) {
      data['amenities'] = this.amenities.map((v) => v.toJson()).toList();
    }
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['name'] = this.name;
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    data['price_offer'] = this.priceOffer;
    data['time_added'] = this.timeAdded;
    return data;
  }
}
