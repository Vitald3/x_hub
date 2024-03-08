class ShortcutsResponseModel {
  List<ShortcutsModel>? data;
  bool? success;
  int? total;

  ShortcutsResponseModel({this.data, this.success, this.total});

  ShortcutsResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShortcutsModel>[];
      json['data'].forEach((v) {
        data!.add(ShortcutsModel.fromJson(v));
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

class ShortcutsModel {
  int? createdAt;
  int? id;
  String? owner;
  String? shortcut;
  String? text;

  ShortcutsModel({this.createdAt, this.id, this.owner, this.shortcut, this.text});

  ShortcutsModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    id = json['id'];
    owner = json['owner'];
    shortcut = json['shortcut'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['id'] = id;
    data['owner'] = owner;
    data['shortcut'] = shortcut;
    data['text'] = text;
    return data;
  }
}