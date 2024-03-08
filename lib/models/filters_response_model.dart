class FiltersResponseModel {
  Filters? data;
  bool? success;

  FiltersResponseModel({this.data});

  FiltersResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Filters.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    return data;
  }
}

class Filters {
  List<String>? accounts;
  List<String>? sharedWith;

  Filters({this.accounts, this.sharedWith});

  Filters.fromJson(Map<String, dynamic> json) {
    accounts = json['accounts'].cast<String>();
    sharedWith = json['shared_with'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accounts'] = accounts;
    data['shared_with'] = sharedWith;
    return data;
  }
}