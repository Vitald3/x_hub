class UserResponse {
  bool? b2faEnabled;
  Billing? billing;
  int? connectorsLimit;
  int? createdAt;
  int? demoEnds;
  String? email;
  int? id;
  List<UserNotifications>? notifications;
  int? phone;
  List<String>? sharedAccess;
  int? sharedLimit;
  int? tId;
  List<String>? toolsAccess;
  Verified? verified;

  UserResponse(
      {this.b2faEnabled,
        this.billing,
        this.connectorsLimit,
        this.createdAt,
        this.demoEnds,
        this.email,
        this.id,
        this.notifications,
        this.phone,
        this.sharedAccess,
        this.sharedLimit,
        this.tId,
        this.toolsAccess,
        this.verified});

  UserResponse.fromJson(Map<String, dynamic> json) {
    b2faEnabled = json['2fa_enabled'];
    billing =
    json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    connectorsLimit = json['connectors_limit'];
    createdAt = json['created_at'];
    demoEnds = json['demo_ends'];
    email = json['email'];
    id = json['id'];
    if (json['notifications'] != null && json['notifications'].isNotEmpty) {
      var arr = <UserNotifications>[];

      try {
        for (var i in json['notifications']) {
          arr.add(UserNotifications.fromJson(i));
        }
      } catch (e) {
        arr.add(UserNotifications.fromJson(json['notifications']));
      }

      notifications = arr;
    } else {
      notifications = [];
    }
    phone = json['phone'];
    if (json['shared_access'] != null && json['shared_access'].isNotEmpty) {
      var arr = <String>[];

      json['shared_access'].forEach((key, value) {
        arr.add(key);
      });

      sharedAccess = arr;
    } else {
      sharedAccess = [];
    }
    sharedLimit = json['shared_limit'];
    tId = json['tarrif'];
    toolsAccess = json['tools_access'].cast<String>();
    verified = json['verifed'] != null ? Verified.fromJson(json['verifed']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['2fa_enabled'] = b2faEnabled;
    if (billing != null) {
      data['billing'] = billing!.toJson();
    }
    data['connectors_limit'] = connectorsLimit;
    data['created_at'] = createdAt;
    data['demo_ends'] = demoEnds;
    data['email'] = email;
    data['id'] = id;
    data['notifications'] = notifications;
    data['phone'] = phone;
    data['shared_access'] = sharedAccess;
    data['shared_limit'] = sharedLimit;
    data['tarrif'] = tId;
    data['tools_access'] = toolsAccess;
    if (verified != null) {
      data['verifed'] = verified!.toJson();
    }
    return data;
  }
}

class Billing {
  String? city;
  String? companyName;
  String? country;
  String? firstName;
  String? lastName;
  dynamic nip;
  String? address;
  String? zip;

  Billing(
      {this.city,
        this.companyName,
        this.country,
        this.firstName,
        this.lastName,
        this.nip,
        this.address,
        this.zip});

  Billing.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    companyName = json['company_name'];
    country = json['country'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    nip = json['nip'];
    address = json['address'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['company_name'] = companyName;
    data['country'] = country;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['nip'] = nip;
    data['address'] =  address;
    data['zip'] = zip;
    return data;
  }
}

class UserNotifications {
  String? field;
  String? name;
  int? state;

  UserNotifications({this.field, this.name, this.state});

  UserNotifications.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    name = json['name'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field'] = field;
    data['name'] = name;
    data['state'] = state;
    return data;
  }
}

class Verified {
  bool? email;
  bool? phone;

  Verified({this.email, this.phone});

  Verified.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}