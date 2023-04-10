part of http;

class ApiResponse {
  String? message;
  String? code;
  Map<dynamic, dynamic> rawJson = {};
  dynamic data = {};

  ApiResponse.fromJson(Map json) {
    rawJson = json;
    code = json['code'];
    message = json['message'];
    data = json['result'];
  }

  ApiResponse.empty();
}
