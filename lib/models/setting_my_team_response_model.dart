class SettingMyTeamResponseModel {
  MyTeam? data;
  bool? success;

  SettingMyTeamResponseModel({this.data, this.success});

  SettingMyTeamResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? MyTeam.fromJson(json['data']) : null;
    success = json['succes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['succes'] = success;
    return data;
  }
}

class TeamItem {
  String? email;
  int? status;

  TeamItem({this.email, this.status});

  TeamItem.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['status'] = status;
    return data;
  }
}

class MyTeam {
  List<TeamItem>? team;

  MyTeam({this.team});

  MyTeam.fromJson(Map<String, dynamic> json) {
    var items = <TeamItem>[];

    if (json['waiting_for_agree'] != null && json['waiting_for_agree'].isNotEmpty) {
      for (var i in json['waiting_for_agree']) {
        if (i['access_for'] != null) {
          items.add(TeamItem(email: i['access_for'], status: 2));
        }
      }
    }

    if (json['team'] != null && json['team'].isNotEmpty) {
      json['team'].forEach((key, value) {
        items.add(TeamItem(email: key, status: value));
      });
    }

    team = items;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['team'] = team;
    return data;
  }
}