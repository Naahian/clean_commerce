import 'dart:io';

class ApiEndpoints {
  static final baseUrl = "https://dummyjson.com";

  //auth
  static final login = "/auth/login";
  static final userInfo = "/auth/me";
  static final refresh = "/auth/refresh";

  //others
  static final users = "/users";
  static final posts = "/posts";
  static final randomImage = "/icon";
}
