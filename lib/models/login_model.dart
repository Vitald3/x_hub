class LoginModel {
  String? email;
  String? password;
  String? deviceType;
  String? deviceId;
  String? fToken;

  LoginModel({
    this.email,
    this.password,
    this.deviceType,
    this.deviceId,
    this.fToken
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    deviceType = json['device_type'];
    deviceId = json['device_id'];
    fToken = json['f_token'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['email'] = email!;
    data['password'] = password!;
    data['device_type'] = "$deviceType";
    data['device_id'] = deviceId!;
    data['f_token'] = fToken!;
    return data;
  }
}