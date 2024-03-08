import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../services/api.dart';

class ChatTranscriptionProvider extends ChangeNotifier {
  bool isLoader = false;
  bool submit = false;
  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();

  Future<void> addTranscription(int id) async {
    final String email = controller.value.text;

    if (email != "" && EmailValidator.validate(email)) {
      if (!submit) {
        setSubmit(true);

        Api.addTranscription(id, email).then((response) {
          controller.clear();
          setSubmit(false);
        });
      }
    } else {
      focus.requestFocus();
    }
  }

  void resetParams() {
    isLoader = false;
    submit = false;
    controller.clear();
  }

  void setSubmit(bool val) {
    submit = val;
    notifyListeners();
  }
}