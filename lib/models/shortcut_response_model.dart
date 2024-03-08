class ShortcutResponseModel {
  String? message;
  int? id;
  bool? success;

  ShortcutResponseModel({
    this.message,
    this.id,
    this.success
  });

  ShortcutResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['id'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['id'] = id;
    data['success'] = success;
    return data;
  }
}