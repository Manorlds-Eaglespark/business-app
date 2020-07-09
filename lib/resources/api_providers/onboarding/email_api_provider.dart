import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mutuuze/models/user_object.dart';

import '../base_url.dart';

class EmailAuthApiProvider {
  Future fetchServerToken(String email, String password, int accountType) async {
    final response = await http.post(
      '${BaseUrl.BASE_URL}/api/v1/user/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password, 'role': "$accountType"}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      UserObject userData = UserObject.fromJson(data);
      return userData;
    } else {
      return response.body.toString();
    }
  }
}
