import 'package:x_hub/models/user_response_model.dart';

class LoginResponseModel {
  bool? success;
  String? accessToken;
  String? message;
  UserResponse? user;

  LoginResponseModel({
    this.success,
    this.accessToken,
    this.message,
    this.user
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    accessToken = json['access_token'];
    message = json['message'];
    if (json['user'] != null) {
      user = UserResponse.fromJson(json['user']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['access_token'] = accessToken;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}