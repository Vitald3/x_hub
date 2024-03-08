import 'package:x_hub/models/chat_response_model.dart';

class MessageDataModel {
  String? message;
  Attachments? attachment;

  MessageDataModel({
    this.message,
    this.attachment
  });

  MessageDataModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['attachments'] != null) {
      attachment = Attachments.fromJson(json['attachments']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (attachment != null) {
      data['attachments'] = attachment!.toJson();
    }
    return data;
  }
}