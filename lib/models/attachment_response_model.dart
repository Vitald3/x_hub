class AttachmentResponseModel {
  String? filename;
  String? url;
  bool? success;

  AttachmentResponseModel({
    this.filename,
    this.url,
    this.success
  });

  AttachmentResponseModel.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    url = json['url'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filename'] = filename;
    data['url'] = url;
    data['success'] = success;
    return data;
  }
}