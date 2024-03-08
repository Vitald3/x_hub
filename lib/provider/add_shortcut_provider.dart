import 'package:flutter/material.dart';
import '../models/shortcuts_response_model.dart';
import '../services/api.dart';

class AddShortcutProvider extends ChangeNotifier {
  bool shortcutAdd = false;
  String? text;
  String? text2;

  Future<void> addShortcut(String shortcut, String text, ShortcutsModel? edit) async {
    shortcutAdd = true;
    notifyListeners();

    await Api.addShortcut(shortcut, text, edit).then((response) {
      shortcutAdd = false;
      notifyListeners();
    });
  }

  void setShortcutAdd(bool val) {
    shortcutAdd = val;
  }

  void setText(String? val) {
    text = val;
  }

  void setText2(String? val) {
    text2 = val;
  }
}