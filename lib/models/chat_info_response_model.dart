import 'package:x_hub/models/user_response_model.dart';

class ChatInfoResponseModel {
  ChatInfo? data;
  bool? success;
  UserResponse? user;

  ChatInfoResponseModel({this.data, this.success, this.user});

  ChatInfoResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ChatInfo.fromJson(json['data']) : null;
    success = json['success'];
    if (json['user'] != null) {
      user = UserResponse.fromJson(json['user']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class ChatInfo {
  List<String>? access;
  List<Files>? files;
  OfferInfo? offerInfo;

  ChatInfo({this.access, this.files, this.offerInfo});

  ChatInfo.fromJson(Map<String, dynamic> json) {
    access = json['access'] != null ? json['access'].cast<String>() : [];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(Files.fromJson(v));
      });
    }
    offerInfo = json['offer_info'] != null
        ? OfferInfo.fromJson(json['offer_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access'] = access;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    if (offerInfo != null) {
      data['offer_info'] = offerInfo!.toJson();
    }
    return data;
  }
}

class Files {
  int? conversationId;
  String? filename;
  int? id;
  String? mimetype;
  String? url;

  Files({this.conversationId, this.filename, this.id, this.mimetype, this.url});

  Files.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversation_id'];
    filename = json['filename'];
    id = json['id'];
    mimetype = json['mimetype'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conversation_id'] = conversationId;
    data['filename'] = filename;
    data['id'] = id;
    data['mimetype'] = mimetype;
    data['url'] = url;
    return data;
  }
}

class OfferInfo {
  String? offerId;
  double? price;
  String? title;

  OfferInfo({this.offerId, this.price, this.title});

  OfferInfo.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    price = json['price'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offer_id'] = offerId;
    data['price'] = price;
    data['title'] = title;
    return data;
  }
}