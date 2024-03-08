import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/route_manager.dart';
import '../models/shortcuts_response_model.dart';
import '../other/constant.dart';
import '../services/api.dart';
import 'add_shortcut_provider.dart';

class SettingShortcutProvider extends ChangeNotifier {
  bool isLoader = false;
  bool submit = false;
  var shortcuts = <ShortcutsModel>[];
  int offset = 0;

  Future<void> getShortcuts() async {
    shortcuts = [];
    offset = 0;
    final provider = Provider.of<AddShortcutProvider>(Get.context!, listen: false);
    provider.setText(null);
    provider.setText2(null);
    provider.setShortcutAdd(false);

    Api.getShortcuts(offset: offset).then((response) {
      if (response.shortcutsResponse != null) {
        if (shortcuts.isEmpty) {
          shortcuts = response.shortcutsResponse!.data!;
        } else {
          for (var i in response.shortcutsResponse!.data ?? []) {
            shortcuts.add(i);
          }
        }

        offset += chatMessageLimit;

        if ((response.shortcutsResponse!.total ?? 0) > offset) {
          getShortcuts();
        } else {
          isLoader = true;
          notifyListeners();
        }
      }
    });
  }

  Future<void> deleteShortcut(int id) async {
    Api.deleteShortcut(id).then((response) {
      if (response.success ?? false) {
        getShortcuts();
      }
    });
  }

  void resetParams() {
    shortcuts = <ShortcutsModel>[];
    offset = 0;
    isLoader = false;
    submit = false;
  }

  void close() {
    Navigator.of(Get.context!).pop();
  }

  void setSubmit(bool val) {
    submit = val;
    notifyListeners();
  }
}