import 'package:x_hub/models/user_response_model.dart';

class ProfileResponse {
  bool? success;
  UserResponse? user;

  ProfileResponse({
    this.success,
    this.user
  });

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    success = json['succes'];
    user = json['data'] != null ? UserResponse.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['succes'] = success;
    if (user != null) {
      data['data'] = user!.toJson();
    }
    return data;
  }
}