import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/route_manager.dart';
import 'chat_list_provider.dart';

class MainLayoutProvider extends ChangeNotifier {
  int _activeTab = 0;
  int get activeTab => _activeTab;
  GlobalKey<NavigatorState>? navigatorKey;
  bool reset = false;

  void resetV() {
    reset = true;
    notifyListeners();
  }

  set activeTab(int index) {
    _activeTab = index;
    notifyListeners();
  }

  void onItemTapped(int index) {
    activeTab = index;
    Provider.of<ChatListProvider>(Get.context!, listen: false).resetParams();
    notifyListeners();
  }
}