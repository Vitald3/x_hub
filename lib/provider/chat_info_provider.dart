import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../models/chat_info_response_model.dart';
import '../services/api.dart';

class ChatInfoProvider extends ChangeNotifier {
  var chatInfo = ChatInfoResponseModel();
  int page = 0;
  PageController? controller;
  bool isLoader = false;
  String accessSelected = '';
  bool submit = false;

  Future<void> getChatInfo(int id) async {
    controller = PageController(initialPage: 0);
    Api.getChatInfo(id).then((response) {
      if (response.chatInfo != null) {
        chatInfo = response.chatInfo!;
      }

      isLoader = true;

      notifyListeners();
    });
  }

  Future<void> removeProvide(int id, String email) async {
    submit = false;
    accessSelected = '';

    Api.removeProvide(id, email).then((response) {
      if (response.success ?? false) {
        getChatInfo(id);
        notifyListeners();
      }
    });
  }

  Future<void> addProvide(int id, String email) async {
    submit = true;

    Api.addProvide(id, email).then((response) {
      if (response.success ?? false) {
        getChatInfo(id);
      }

      submit = false;
      accessSelected = '';
      notifyListeners();
    });
  }

  void setAccessSelected(String? val) {
    if (val != null && val != tr('text_select')) {
      accessSelected = val;
      notifyListeners();
    }
  }

  void resetParams() {
    controller?.dispose();
    page = 0;
    isLoader = false;
    chatInfo = ChatInfoResponseModel();
  }

  void setPage(int val) {
    page = val;
    controller?.animateToPage(val, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    notifyListeners();
  }

}