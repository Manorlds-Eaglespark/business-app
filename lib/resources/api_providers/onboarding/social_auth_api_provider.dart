import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mutuuze/models/user_object.dart';

import '../base_url.dart';

class SocialAuthApiProvider {
  Future fetchServerToken(String token, String provider) async {
    final response = await http.post(
      '${BaseUrl.BASE_URL}/api/v1/user/login/social',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'provider': provider, 'token': token}),
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
