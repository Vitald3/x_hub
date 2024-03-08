import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../other/extensions.dart';
import '../services/api.dart';

class SettingChangePasswordProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final focus = FocusNode();
  final TextEditingController controller2 = TextEditingController();
  final focus2 = FocusNode();
  bool submitButton = false;
  bool passwordHide = true;
  bool passwordHide2 = true;
  final state = GlobalKey<FormFieldState>();

  void setPasswordHide() {
    passwordHide = !passwordHide;
    notifyListeners();
  }

  void setPasswordHide2() {
    passwordHide2 = !passwordHide;
    notifyListeners();
  }

  void change() async {
    FocusScope.of(Get.context!).unfocus();
    final String password = controller.value.text;
    final String confirm = controller2.value.text;

    if (confirm != "" && password != "" && confirm == password) {
      if (!submitButton) {
        submitButton = true;
        notifyListeners();

        Api.changePassword(password).then((response) {
          submitButton = false;
          notifyListeners();

          if (response.success ?? false) {
            snackBar(text: tr('text_change_success'), callback: () {
              Get.back();
              controller.clear();
              controller2.clear();
              Get.back();
            });
          }
        });
      }
    } else {
      if (password == "") {
        focus.requestFocus();
      } else if (confirm == "" || password != confirm) {
        focus2.requestFocus();
      }
    }
  }
}