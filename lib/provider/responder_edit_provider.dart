import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:x_hub/models/auto_responder_response_model.dart';
import 'package:x_hub/other/extensions.dart';
import '../models/setting_connected_account_response_model.dart';
import '../services/api.dart';

class ResponderEditProvider extends ChangeNotifier {
  bool submitButton = false;
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  final focus = FocusNode();
  final focus2 = FocusNode();
  var day = <int>[];
  var connectors = <int>[];
  String from = '';
  String to = '';
  int after = 0;
  var connectedAccounts = <ConnectedAccount>[];
  bool isLoader = false;
  
  void setItem(RespondersModel item) {
    controller.text = item.name!;
    controller2.text = item.rules!.hours!.from!;
    from = item.rules!.hours!.from!;
    to = item.rules!.hours!.to!;
    after = item.rules!.replyDelay ?? 0;
    controller3.text = item.rules!.hours!.to!;
    controller4.text = item.rules!.replyDelay != null ? '${item.rules!.replyDelay} minutes' : '';
    controller5.text = item.message!;
    connectors = item.connectors ?? [];
    day = [];

    if ((item.rules!.days!.mo ?? 0) == 1) {
      day.add(1);
    }

    if ((item.rules!.days!.tu ?? 0) == 1) {
      day.add(2);
    }

    if ((item.rules!.days!.we ?? 0) == 1) {
      day.add(3);
    }

    if ((item.rules!.days!.th ?? 0) == 1) {
      day.add(4);
    }

    if ((item.rules!.days!.fr ?? 0) == 1) {
      day.add(5);
    }

    if ((item.rules!.days!.sa ?? 0) == 1) {
      day.add(6);
    }

    if ((item.rules!.days!.su ?? 0) == 1) {
      day.add(7);
    }
  }

  void setFrom(String val) {
    from = val;
  }

  Future<void> getConnected() async {
    final response = await Api.getConnected();

    if (response.settingConnectedAccountResponse != null) {
      connectedAccounts = response.settingConnectedAccountResponse!.data!;
    }

    isLoader = true;
    notifyListeners();
  }

  void setConnectors(List<int> val) {
    connectors = val;
    notifyListeners();
  }

  void setConnector(int val) {
    connectors.add(val);
  }

  void deleteConnector(int val) {
    connectors.remove(val);
  }

  void setAfter(int val) {
    after = val;
    notifyListeners();
  }

  void setTo(String val) {
    to = val;
  }

  void update() {
    notifyListeners();
  }

  void setDays(int val) {
    if (day.contains(val)) {
      day.remove(val);
    } else {
      day.add(val);
    }

    notifyListeners();
  }

  Future<void> addResponder({int id = 0}) async {
    final String name = controller.value.text;
    final String message = controller5.value.text;

    if (name != "" && message != '' && connectors.isNotEmpty && day.isNotEmpty && (controller2.text != '' && controller3.text != '' || (controller2.text != '' && controller3.text == '') || (controller2.text == '' && controller3.text != ''))) {
      if (!submitButton) {
        submitButton = true;
        notifyListeners();

        final data = {
          "name": controller.value.text,
          "connectors": connectors,
          "rules": {
            "reply_delay": int.tryParse(controller4.value.text.replaceAll(' minutes', '')) ?? 0,
            "days": {
              "mo": day.contains(1) ? 1 : 0,
              "tu": day.contains(2) ? 1 : 0,
              "we": day.contains(3) ? 1 : 0,
              "th": day.contains(4) ? 1 : 0,
              "fr": day.contains(5) ? 1 : 0,
              "sa": day.contains(6) ? 1 : 0,
              "su": day.contains(7) ? 1 : 0,
            },
            "hours": {
              "from": controller2.value.text,
              "to": controller3.value.text
            }
          },
          "message": controller5.value.text
        };

        if (id > 0) {
          await Api.updateResponder(id, data);
        } else {
          await Api.addResponder(data);
        }

        submitButton = false;
        notifyListeners();
      }
    } else {
      if (name == '') {
        focus.requestFocus();
      } else if (message == '') {
        focus2.requestFocus();
      }

      if (connectors.isEmpty) {
        snackBar(text: tr('text_select_accounts'), error: true);
      } else if (day.isEmpty) {
        snackBar(text: tr('text_select_day'), error: true);
      } else if (controller2.text != '' && controller3.text == '') {
        snackBar(text: tr('text_select_to'), error: true);
      }
    }
  }

  void resetParams() {
    controller.clear();
    controller2.clear();
    controller3.clear();
    controller4.clear();
    controller5.clear();
    day = [];
    from = '';
    to = '';
    after = 0;
    connectors = [];
    connectedAccounts = [];
  }
}