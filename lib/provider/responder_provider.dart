import 'package:flutter/cupertino.dart';
import '../models/auto_responder_response_model.dart';
import '../services/api.dart';

class ResponderProvider extends ChangeNotifier {
  var responders = <RespondersModel>[];
  bool isLoader = false;

  void getResponders() async {
    final response = await Api.getResponders();

    if (response.autoResponderResponseModel != null) {
      responders = response.autoResponderResponseModel!.responders!;
      notifyListeners();
    }

    isLoader = true;
  }

  void removeResponder(int id) {
    Api.removeResponder(id).then((response) {
      if (response.success ?? false) {
        getResponders();
      }
    });
  }

  void resetParams() {

  }
}