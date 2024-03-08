import 'chat_list_response_model.dart';

class ChatResponseModel {
  List<DataChat>? data;
  bool? success;
  int? total;
  int? qtyAfter;
  int? qtyBefore;
  DataChatList? conversation;

  ChatResponseModel({this.data, this.success, this.total});

  ChatResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataChat>[];
      json['data'].forEach((v) {
        data!.add(DataChat.fromJson(v));
      });
    }
    success = json['success'];
    total = json['total'];
    qtyAfter = json['qty_after'];
    qtyBefore = json['qty_before'];
    conversation = json['conversation'] != null
        ? DataChatList.fromJson(json['conversation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conversation != null) {
      data['conversation'] = conversation!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['qty_after'] = qtyAfter;
    data['qty_before'] = qtyBefore;
    data['total'] = total;
    return data;
  }
}

class Attachments {
  String? filename;
  String? url;

  Attachments({
    this.filename,
    this.url
  });

  Attachments.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filename'] = filename;
    data['url'] = url;
    return data;
  }
}

class DataChat {
  List<Attachments>? attachments;
  int? conversationId;
  int? createdAt;
  int? id;
  String? message;
  String? sender;
  int? status;
  bool? youSender;

  DataChat(
      {this.attachments,
        this.conversationId,
        this.createdAt,
        this.id,
        this.message,
        this.sender,
        this.status,
        this.youSender});

  DataChat.fromJson(Map<String, dynamic> json) {
    if (json['attachments'] != null && json['attachments'] is List) {
      var data = <Attachments>[];

      json['attachments'].forEach((v) {
        data.add(Attachments.fromJson(v));
      });

      attachments = data;
    } else {
      attachments = json['attachments'] != null ? [Attachments.fromJson(json['attachments'])] : [];
    }
    conversationId = json['conversation_id'];
    createdAt = json['created_at'];
    id = json['id'];
    message = json['message'];
    sender = json['sender'];
    status = json['status'];
    youSender = json['you_sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attachments'] = attachments;
    data['conversation_id'] = conversationId;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['message'] = message;
    data['sender'] = sender;
    data['status'] = status;
    data['you_sender'] = youSender;
    return data;
  }
}