class SettingConnectedAccountResponseModel {
  List<ConnectedAccount>? data;
  bool? success;
  int? total;

  SettingConnectedAccountResponseModel({this.data, this.success, this.total});

  SettingConnectedAccountResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ConnectedAccount>[];
      json['data'].forEach((v) {
        data!.add(ConnectedAccount.fromJson(v));
      });
    }
    success = json['success'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['total'] = total;
    return data;
  }
}

class ConnectedAccount {
  String? authLink;
  int? createdAt;
  int? id;
  String? owner;
  String? service;
  int? status;
  String? username;

  ConnectedAccount(
      {this.authLink,
        this.createdAt,
        this.id,
        this.owner,
        this.service,
        this.status,
        this.username});

  ConnectedAccount.fromJson(Map<String, dynamic> json) {
    authLink = json['auth_link'];
    createdAt = json['created at'];
    id = json['id'];
    owner = json['owner'];
    service = json['service'];
    status = json['status'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['auth_link'] = authLink;
    data['created at'] = createdAt;
    data['id'] = id;
    data['owner'] = owner;
    data['service'] = service;
    data['status'] = status;
    data['username'] = username;
    return data;
  }
}