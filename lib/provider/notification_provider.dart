import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../models/user_response_model.dart';
import '../services/api.dart';

class NotificationProvider extends ChangeNotifier {
  var notifications = <UserNotifications>[];

  void resetParams() {
    notifications = [];
  }

  Future<void> getProfile() async {
    await Api.getProfile().then((value) {
      notifications = value.profileResponse?.user?.notifications ?? [];
      notifyListeners();
    });
  }

  void confirm(UserNotifications item, bool toggle) {
    Api.notification({'${item.field}': toggle ? 1 : 0});
  }
}