import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/route_manager.dart';
import 'chat_list_provider.dart';

class FiltersProvider extends ChangeNotifier {
  String? selected;
  String? selected2;
  bool start = false;

  void setSelected(String? val) {
    selected = val;
    start = true;
    notifyListeners();
  }

  void setSelected2(String? val) {
    selected2 = val;
    start = true;
    notifyListeners();
  }

  Future<void> chatList(bool reset, BuildContext context) async {
    if (start) {
      if (reset) {
        selected = null;
        selected2 = null;
      }

      Provider.of<ChatListProvider>(Get.context!, listen: false).getChatList(reset: true);
    }

    Navigator.of(context).pop();
  }

  void resetParams() {
    selected = null;
    selected2 = null;
    start = false;
  }
}