import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mutuuze/models/category.dart';

import 'base_url.dart';

class CategoriesApiProvider {
  Future<List<Category>> fetchAllCategories() async {
    final response = await http.get(
      '${BaseUrl.BASE_URL}/api/v1/categories',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      List categoriesList = jsonDecode(response.body);
      return categoriesList.map((f) => Category.fromJson(f)).toList();
    }
    return [];
  }
}
