import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mutuuze/models/property.dart';

import 'base_url.dart';


class GeneralSearchApiProvider {
  Future<List<Property>> fetchGeneralSearchResults(String searchQuery) async {
    final response = await http.post(
      '${BaseUrl.BASE_URL}/api/v1/properties/search',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'search': searchQuery}),
    );

    if (response.statusCode == 200) {
      List searchResults = jsonDecode(response.body);
      return searchResults.map<Property>((f) => Property.fromJson(f)).toList();
    }
    return [];
  }
}
