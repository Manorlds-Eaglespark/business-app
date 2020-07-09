class Amenities {
  int id;
  int propertyId;
  String description;
  int icon;

  Amenities({this.id, this.propertyId, this.description, this.icon});

  Amenities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['description'] = this.description;
    data['icon'] = this.icon;
    return data;
  }
}
