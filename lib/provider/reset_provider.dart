import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../services/api.dart';
import '../views/confirmation_view.dart';

class ResetProvider extends ChangeNotifier {
  bool submitButton = false;
  TextEditingController controller = TextEditingController();
  final focus = FocusNode();

  Future<void> reset() async {
    FocusScope.of(Get.context!).unfocus();
    final String email = controller.value.text;

    if (email != "" && EmailValidator.validate(email)) {
      if (!submitButton) {
        submitButton = true;
        notifyListeners();
        final response = await Api.getCode(email, type: 'reset_password');

        if (response.success ?? false) {
          submitButton = false;
          controller.clear();
          notifyListeners();
          Get.to(() => ConfirmationView(email: email, reset: true));
        } else {
          submitButton = false;
          notifyListeners();
        }
      }
    } else {
      focus.requestFocus();
    }
  }
}