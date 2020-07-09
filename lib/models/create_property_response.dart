import 'package:mutuuze/models/property.dart';

class CreatePropertyResponse {
  String message;
  Property property;

  CreatePropertyResponse({this.message, this.property});

  CreatePropertyResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    property = json['property'] != null
        ? new Property.fromJson(json['property'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.property != null) {
      data['property'] = this.property.toJson();
    }
    return data;
  }
}