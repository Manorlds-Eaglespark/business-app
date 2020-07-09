import 'dart:convert';
import 'dart:io';
import 'package:mutuuze/models/property.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../base_url.dart';

class PropertyApiProvider {
  Future<List<Property>> fetchAllPropertyByCategoryId(categoryId) async {
    final response = await http.get(
      '${BaseUrl.BASE_URL}/api/v1/properties/category/$categoryId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      List propertyList = jsonDecode(response.body);
      return propertyList.map((f) => Property.fromJson(f)).toList();
    }
    return [];
  }

  Future<List<Property>> fetchAllPropertyByAgentId(agentId) async {
    final response = await http.get(
      '${BaseUrl.BASE_URL}/api/v1/properties/agent/$agentId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      List propertyList = jsonDecode(response.body);
      return propertyList.map((f) => Property.fromJson(f)).toList();
    }
    return [];
  }


  Future uploadPropertyImages(File image, propertyId, token) async{


    print("******************************************* now inside upload method");
    print(image);

    Dio dio = Dio();
    try {
      Map<String, dynamic> _documentFormData = {};

      if (image != null) {
        _documentFormData['my_file'] = MultipartFile.fromFileSync(image.path);
      }
      FormData formData = FormData.fromMap(_documentFormData);
//      FormData formData =
//      new FormData.fromMap({"file":  image});
      var url = '${BaseUrl.BASE_URL}/api/v1/property/create/$propertyId/images';
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        "Content-Type": "multipart/form-data",
      };
      Response response = await dio.post(url,
          data: formData,
          options: Options(
              method: 'POST',
              headers: headers,
              responseType: ResponseType.json // or ResponseType.JSON
          ));

      print(response);
    } catch (e) {}

  }


  Future sendNewPropertyDetails(
      token, propDetails, imagesList) async {
    final response = await http.post(
      '${BaseUrl.BASE_URL}/api/v1/property/create',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(propDetails),
    );


    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      uploadPropertyImages(imagesList[0], responseData['property']['id'], token);
    }
//    return response.body;
  }
}
