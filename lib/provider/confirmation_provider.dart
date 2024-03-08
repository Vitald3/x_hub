import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../other/extensions.dart';
import '../services/api.dart';
import '../views/success_view.dart';

class ConfirmationProvider extends ChangeNotifier {
  String email = '';
  String tokenStr = '';
  String code = '';
  bool reset = false;
  bool editing = false;
  bool submitButton = false;
  int count = 60;
  String strCount = '60';
  Timer? timer;

  void setEmail(String val) {
    email = val;
  }

  void setStrToken(String val) {
    tokenStr = val;
  }

  void setReset(bool val) {
    reset = val;
  }

  void resetParams() {
    code = '';
    editing = false;
    count = 60;
    strCount = '60';
    timer?.cancel();
    timer = null;
    email = '';
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      count--;

      if (count > 9) {
        strCount = '$count';
      } else {
        strCount = '0$count';
      }

      if (count == 0) {
        timer.cancel();
      }

      notifyListeners();
    });
  }

  void setCode(String value) {
    code = value;

    notifyListeners();
  }

  void setToken() async {
    token = tokenStr;
    setting?.put('token', tokenStr);
    notifyListeners();
  }

  Future<void> confirm() async {
    submitButton = true;
    notifyListeners();
    final response = await Api.confirm(email, code, type: reset ? 'reset_password' : 'registration');

    if (response.success ?? false) {
      snackBar(text: tr('text_confirmed'));
      submitButton = false;

      if (!reset) {
        setToken();
      }

      resetParams();

      if (!reset) {
        Get.offAllNamed('/');
      } else {
        Get.to(() => const SuccessView());
      }
    } else {
      submitButton = false;
      notifyListeners();
    }
  }

  void setEditing(bool value) {
    editing = value;
    notifyListeners();
  }

  Future<void> reSend() async {
    await Api.getCode(email).then((value) {
      if (value.success ?? false) {
        snackBar(text: tr('text_resend'));
        code = '';
        editing = false;
        count = 60;
        strCount = '60';
        startTimer();
      }
    });
  }

  void getCode() async {
    Api.getCode(email);
    startTimer();
  }
}