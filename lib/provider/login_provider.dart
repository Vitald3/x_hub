import 'package:flutter/cupertino.dart';
import 'package:get/route_manager.dart';
import '../main.dart';
import '../models/login_model.dart';
import '../other/extensions.dart';
import '../services/api.dart';
import '../views/confirmation_view.dart';
import '../views/main_layout.dart';

class LoginProvider extends ChangeNotifier {
  bool submitButton = false;
  bool passwordHide = true;
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  final focus = FocusNode();
  final focus2 = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  void setSubmit(bool val) {
    submitButton = val;
    notifyListeners();
  }

  void setToken(String val) async {
    token = val;
    setting?.put('token', val);
    notifyListeners();
  }

  void setPasswordHide() {
    passwordHide = !passwordHide;
    notifyListeners();
  }

  void login() async {
    FocusScope.of(Get.context!).unfocus();
    final String email = controller.value.text;
    final String password = controller2.value.text;

    if (email != "" && password != "") {
      if (!submitButton) {
        setSubmit(true);

        Api.login(LoginModel(email: email, password: password, deviceId: await getDeviceId(), fToken: setting?.get('f_token', defaultValue: ''))).then((response) {
          setSubmit(false);

          if (response.loginResponse?.success ?? false) {
            controller.clear();
            controller2.clear();

            if (response.loginResponse?.user != null && response.loginResponse?.user?.verified?.email != null && !(response.loginResponse!.user!.verified!.email ?? false)) {
              Get.to(() => ConfirmationView(email: email, token: response.loginResponse!.accessToken!));
            } else {
              setToken(response.loginResponse!.accessToken!);
              Get.to(() => MainLayoutView());
            }
          }
        });
      }
    } else {
      if (email == "") {
        focus.requestFocus();
      } else if (password == "") {
        focus2.requestFocus();
      }
    }
  }
}