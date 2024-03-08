import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:x_hub/models/setting_my_team_response_model.dart';
import '../services/api.dart';

class SettingMyTeamProvider extends ChangeNotifier {
  var myTeam = <TeamItem>[];
  bool isLoader = false;
  bool submit = false;
  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();
  String accessSelected = 'Limit access';

  Future<void> getMyTeam() async {
    Api.getMyTeam().then((response) {
      if (response.settingMyTeamResponseModel != null && response.settingMyTeamResponseModel!.data!.team != null) {
        myTeam = response.settingMyTeamResponseModel!.data!.team!;
      }

      isLoader = true;
      notifyListeners();
    });
  }

  Future<void> addMyTeam() async {
    final String email = controller.value.text;

    if (email != "") {
      if (!submit) {
        setSubmit(true);

        Api.addMyTeam(email, accessSelected == 'Limit access' ? 0 : 1).then((response) {
          setSubmit(false);

          if (response.success ?? false) {
            getMyTeam();
            controller.clear();
          }
        });
      }
    } else {
      focus.requestFocus();
    }
  }

  Future<void> deleteMyTeam(String email) async {
    Api.deleteMyTeam(email).then((response) {
      if (response.success ?? false) {
        getMyTeam();
      }
    });
  }

  void resetParams() {
    myTeam = <TeamItem>[];
    isLoader = false;
    submit = false;
  }

  void setAccessSelected(String val) {
    accessSelected = val;
    notifyListeners();
  }

  String getStatus(int status) {
    String str = '';

    if (status == 2) {
      str = tr('text_wait_for_accept');
    } else if (status == 0) {
      str = tr('text_limited_access');
    } else if (status == 1) {
      str = tr('text_full_access');
    }

    return str;
  }

  void setSubmit(bool val) {
    submit = val;
    notifyListeners();
  }
}