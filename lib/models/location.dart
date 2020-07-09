class Location {
  int id;
  int propertyId;
  double latitude;
  double longitude;
  String description;

  Location(
      {this.id,
      this.propertyId,
      this.latitude,
      this.longitude,
      this.description});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['description'] = this.description;
    return data;
  }
}
