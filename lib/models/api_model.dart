import 'package:x_hub/models/attachment_response_model.dart';
import 'package:x_hub/models/filters_response_model.dart';
import 'package:x_hub/models/profile_response_model.dart';
import 'package:x_hub/models/setting_connected_account_response_model.dart';
import 'package:x_hub/models/setting_my_team_response_model.dart';
import 'package:x_hub/models/shortcut_response_model.dart';
import 'package:x_hub/models/shortcuts_response_model.dart';
import 'auto_responder_response_model.dart';
import 'chat_info_response_model.dart';
import 'chat_list_response_model.dart';
import 'chat_response_model.dart';
import 'login_response_model.dart';

class ApiModel {
  String? error;
  String? message;
  String? authUrl;
  bool? success;
  int? code;
  LoginResponseModel? loginResponse;
  ChatListResponseModel? chatListResponse;
  ChatResponseModel? chatResponse;
  FiltersResponseModel? filtersResponse;
  AttachmentResponseModel? attachmentResponse;
  ShortcutsResponseModel? shortcutsResponse;
  ShortcutResponseModel? shortcutResponse;
  ChatInfoResponseModel? chatInfo;
  SettingConnectedAccountResponseModel? settingConnectedAccountResponse;
  SettingMyTeamResponseModel? settingMyTeamResponseModel;
  AutoResponderResponseModel? autoResponderResponseModel;
  ProfileResponse? profileResponse;

  ApiModel({
    this.error,
    this.success,
    this.message,
    this.authUrl,
    this.code,
    this.loginResponse,
    this.chatListResponse,
    this.chatResponse,
    this.filtersResponse,
    this.attachmentResponse,
    this.shortcutsResponse,
    this.shortcutResponse,
    this.chatInfo,
    this.settingConnectedAccountResponse,
    this.settingMyTeamResponseModel,
    this.autoResponderResponseModel,
    this.profileResponse
  });

  ApiModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    success = json['success'];
    message = json['message'];
    authUrl = json['auth_url'];
    code = json['code'];
    loginResponse = json['login_response'];
    chatListResponse = json['chat_list_response'];
    chatResponse = json['chat_response'];
    filtersResponse = json['filters_response'];
    attachmentResponse = json['attachment_response'];
    shortcutsResponse = json['shortcuts_response'];
    shortcutResponse = json['shortcut_response'];
    chatInfo = json['chat_info'];
    settingConnectedAccountResponse = json['setting_connected_account_response'];
    settingMyTeamResponseModel = json['setting_my_team_response_model'];
    autoResponderResponseModel = json['auto_responder_response_model'];
    profileResponse = json['profile_response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['success'] = success;
    data['message'] = message;
    data['auth_url'] = authUrl;
    data['code'] = code;
    data['login_response'] = loginResponse;
    data['chat_list_response'] = chatListResponse;
    data['chat_response'] = chatResponse;
    data['filters_response'] = filtersResponse;
    data['attachment_response'] = attachmentResponse;
    data['shortcuts_response'] = shortcutsResponse;
    data['shortcut_response'] = shortcutResponse;
    data['chat_info'] = chatInfo;
    data['setting_connected_account_response'] = settingConnectedAccountResponse;
    data['setting_my_team_responseModel'] = settingMyTeamResponseModel;
    data['auto_responder_response_model'] = autoResponderResponseModel;
    data['profile_response'] = profileResponse;
    return data;
  }
}