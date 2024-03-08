class AutoResponderResponseModel {
  List<RespondersModel>? responders;
  bool? success;
  int? total;

  AutoResponderResponseModel({this.responders, this.success, this.total});

  AutoResponderResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      responders = <RespondersModel>[];
      json['data'].forEach((v) {
        responders!.add(RespondersModel.fromJson(v));
      });
    }
    success = json['success'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (responders != null) {
      data['responders'] = responders!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['total'] = total;
    return data;
  }
}

class RespondersModel {
  List<int>? connectors;
  int? createdAt;
  int? id;
  String? message;
  String? name;
  String? owner;
  Rules? rules;
  int? status;

  RespondersModel(
      {this.connectors,
        this.createdAt,
        this.id,
        this.message,
        this.name,
        this.owner,
        this.rules,
        this.status});

  RespondersModel.fromJson(Map<String, dynamic> json) {
    connectors = json['connectors'].cast<int>();
    createdAt = json['created_at'];
    id = json['id'];
    message = json['message'];
    name = json['name'];
    owner = json['owner'];
    rules = json['rules'] != null ? Rules.fromJson(json['rules']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['connectors'] = connectors;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['message'] = message;
    data['name'] = name;
    data['owner'] = owner;
    if (rules != null) {
      data['rules'] = rules!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Rules {
  Days? days;
  Hours? hours;
  int? replyDelay;

  Rules({this.days, this.hours, this.replyDelay});

  Rules.fromJson(Map<String, dynamic> json) {
    days = json['days'] != null ? Days.fromJson(json['days']) : null;
    hours = json['hours'] != null ? Hours.fromJson(json['hours']) : null;
    replyDelay = json['reply_delay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (days != null) {
      data['days'] = days!.toJson();
    }
    if (hours != null) {
      data['hours'] = hours!.toJson();
    }
    data['reply_delay'] = replyDelay;
    return data;
  }
}

class Days {
  int? fr;
  int? mo;
  int? sa;
  int? su;
  int? th;
  int? tu;
  int? we;

  Days({this.fr, this.mo, this.sa, this.su, this.th, this.tu, this.we});

  Days.fromJson(Map<String, dynamic> json) {
    fr = json['fr'];
    mo = json['mo'];
    sa = json['sa'];
    su = json['su'];
    th = json['th'];
    tu = json['tu'];
    we = json['we'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fr'] = fr;
    data['mo'] = mo;
    data['sa'] = sa;
    data['su'] = su;
    data['th'] = th;
    data['tu'] = tu;
    data['we'] = we;
    return data;
  }
}

class Hours {
  String? from;
  String? to;

  Hours({this.from, this.to});

  Hours.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}