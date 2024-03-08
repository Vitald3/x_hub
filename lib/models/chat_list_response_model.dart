import 'package:x_hub/models/user_response_model.dart';

class ChatListResponseModel {
  List<DataChatList>? data;
  bool? success;
  int? total;
  UserResponse? user;

  ChatListResponseModel({this.data, this.success, this.total, this.user});

  ChatListResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataChatList>[];
      json['data'].forEach((v) {
        data!.add(DataChatList.fromJson(v));
      });
    }
    success = json['success'];
    total = json['total'];
    if (json['user'] != null) {
      user = UserResponse.fromJson(json['user']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['total'] = total;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class DataChatList {
  String? comment;
  int? connectorId;
  String? conversationType;
  int? createdAt;
  int? conversationId;
  String? createdBy;
  String? sender;
  String? message;
  int? id;
  LastMessage? lastMessage;
  String? owner;
  String? service;
  String? serviceLogin;
  String? title;
  int? unread;
  List<String>? access;

  DataChatList(
      {this.comment,
        this.connectorId,
        this.conversationType,
        this.createdAt,
        this.conversationId,
        this.createdBy,
        this.sender,
        this.message,
        this.id,
        this.lastMessage,
        this.owner,
        this.service,
        this.serviceLogin,
        this.title,
        this.unread,
        this.access});

  DataChatList.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    connectorId = json['connector_id'];
    conversationType = json['conversation_type'];
    createdAt = json['created_at'];
    conversationId = json['conversation_id'];
    createdBy = json['created_by'];
    sender = json['sender'];
    message = json['message'];
    id = json['id'];
    lastMessage = json['last_message'] != null
        ? LastMessage.fromJson(json['last_message'])
        : null;
    owner = json['owner'];
    service = json['service'];
    serviceLogin = json['service_login'];
    title = json['title'];
    unread = json['unread'];
    access = json['access'] != null ? json['access'].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['connector_id'] = connectorId;
    data['conversation_type'] = conversationType;
    data['created_at'] = createdAt;
    data['conversation_id'] = conversationId;
    data['created_by'] = createdBy;
    data['sender'] = sender;
    data['message'] = message;
    data['id'] = id;
    if (lastMessage != null) {
      data['last_message'] = lastMessage!.toJson();
    }
    data['owner'] = owner;
    data['service'] = service;
    data['service_login'] = serviceLogin;
    data['title'] = title;
    data['unread'] = unread;
    data['access'] = access;
    return data;
  }
}

class LastMessage {
  int? createdAt;
  String? message;
  String? sender;

  LastMessage({this.createdAt, this.message, this.sender});

  LastMessage.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    message = json['message'];
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['message'] = message;
    data['sender'] = sender;
    return data;
  }
}