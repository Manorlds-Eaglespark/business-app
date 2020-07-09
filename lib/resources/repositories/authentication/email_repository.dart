import 'dart:async';

import 'package:mutuuze/resources/api_providers/onboarding/email_api_provider.dart';


class EmailAuthRepository {
  final emailAuthApiProvider = EmailAuthApiProvider();

  Future loginUser(String email, String password, int accountType) =>
      emailAuthApiProvider.fetchServerToken(email, password, accountType);
}
