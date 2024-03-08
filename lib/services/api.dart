import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:x_hub/models/message_data_model.dart';
import 'package:x_hub/models/profile_response_model.dart';
import 'package:x_hub/models/setting_connected_account_response_model.dart';
import 'dart:async';
import 'dart:convert';
import '../main.dart';
import '../models/api_model.dart';
import '../models/attachment_response_model.dart';
import '../models/auto_responder_response_model.dart';
import '../models/chat_info_response_model.dart';
import '../models/chat_list_response_model.dart';
import '../models/chat_response_model.dart';
import '../models/filters_response_model.dart';
import '../models/login_model.dart';
import '../models/login_response_model.dart';
import '../models/setting_my_team_response_model.dart';
import '../models/shortcut_response_model.dart';
import '../models/shortcuts_response_model.dart';
import '../other/constant.dart';
import '../other/extensions.dart';
import 'package:get/route_manager.dart';
import 'dart:io';
import '../other/ios_downloader.dart';

class Api {
  static Future<ApiModel> login(LoginModel body) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final response = await http.post(Uri.parse(loginUrl), headers: headers, body: jsonEncode(body));

    try {
      final LoginResponseModel model = LoginResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, loginResponse: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> getCode(String email, {String type = 'registration'}) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final response = await http.post(Uri.parse(getCodeUrl), headers: headers, body: jsonEncode({
      "type": type,
      "email": email
    }));

    try {
      final LoginResponseModel model = LoginResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> getProfile() async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.get(Uri.parse(userUrl), headers: headers);

    try {
      final ProfileResponse model = ProfileResponse.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, profileResponse: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> notification(Map<String, dynamic> body) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.put(Uri.parse(updateNotificationUrl), headers: headers, body: jsonEncode(body));

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> updateProfile(Map<String, dynamic> body) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.put(Uri.parse(updateProfileUrl), headers: headers, body: jsonEncode(body));

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> changePassword(String password) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(Uri.parse(changePasswordUrl), headers: headers, body: jsonEncode({
      "password": password
    }));

    try {
      final LoginResponseModel model = LoginResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> confirm(String email, String code, {String type = 'registration'}) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final response = await http.post(Uri.parse(confirmUrl), headers: headers, body: jsonEncode({
      "type": type,
      "email": email,
      "code": code
    }));

    try {
      final LoginResponseModel model = LoginResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> register(LoginModel body) async {
    var headers = {
      'Content-Type': 'application/json'
    };

    var request = http.Request('POST', Uri.parse(registerUrl));
    request.body = jsonEncode(body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    try {
      final LoginResponseModel model = LoginResponseModel.fromJson(jsonDecode(await response.stream.bytesToString()));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, loginResponse: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> getChatList({int offset = 0, String account = '', String sharedWith = '', String search = ''}) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    var params = <String>[];
    String query = '';

    if (offset > 0) {
      params.add('offset=$offset');
    }

    if (account != '') {
      params.add('account=$account');
    }

    if (sharedWith != '') {
      params.add('shared_with=$sharedWith');
    }

    if (params.isNotEmpty) {
      if (search != '') {
        query = 'search?query=$search&${params.join('&')}';
      } else {
        query = '?${params.join('&')}';
      }
    } else if (search != '') {
        query = 'search?query=$search';
    }

    final response = await http.get(Uri.parse('$chatListUrl/$query'), headers: headers);

    try {
      final ChatListResponseModel model = ChatListResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, chatListResponse: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> getChat(int id, {int? offset = 0, int? before = 0}) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    var params = <String>[];
    String query = '';

    if ((before ?? 0) > 0) {
      params.add('before=$before');
    }

    if ((offset ?? 0) > 0) {
      params.add('offset=$offset');
    }

    if (params.isNotEmpty) {
      query = '?${params.join('&')}';
    }

    final response = await http.get(Uri.parse('$chatListUrl/$id$query'), headers: headers);

    try {
      final ChatResponseModel model = ChatResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, chatResponse: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> sendMessage(int id, MessageDataModel message) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(Uri.parse('$chatListUrl/$id/new_message'), headers: headers, body: jsonEncode(message));

    try {
      final ChatResponseModel model = ChatResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> getFilters() async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.get(Uri.parse(filtersUrl), headers: headers);

    try {
      final FiltersResponseModel model = FiltersResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, filtersResponse: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> loadFiles(int id, PlatformFile attachment) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(fileUploadUrl));
    request.fields['attached_to'] = 'conversation';
    request.fields['conversation_id'] = '$id';
    request.files.add(await http.MultipartFile.fromPath('file', attachment.path!, contentType: MediaType('application', attachment.extension!)));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    try {
      final AttachmentResponseModel model = AttachmentResponseModel.fromJson(jsonDecode(await response.stream.bytesToString()));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true, attachmentResponse: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<String> downloadFile(String url, String fileName) async {
    String load = '';

    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    if (Platform.isIOS) {
      final ios = IosDownload();
      load = await ios.downloadMedia(Get.context!, url, fileName);
    } else {
      await FileDownloader.downloadFile(
          url: url,
          name: fileName,
          notificationType: NotificationType.all,
          onDownloadCompleted: (String path) {
            load = path;
            snackBar(text: tr('success_download'));
          },
          headers: headers,
          onDownloadError: (String error) {
            snackBar(error: true, text: error);
          });
    }

    return load;
  }

  static Future<ApiModel> getShortcuts({int offset = 0}) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.get(Uri.parse('$shortcutsUrl${offset > 0 ? '/?offset=$offset' : '/'}'), headers: headers);

    try {
      final ShortcutsResponseModel model = ShortcutsResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, shortcutsResponse: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> addShortcut(String shortcut, String text, ShortcutsModel? edit) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse(edit == null ? addShortcutUrl : '$shortcutsUrl/${edit.id}/edit'),
        headers: headers,
        body: jsonEncode({
          'shortcut': shortcut,
          'text': text
        })
    );

    try {
      final ShortcutResponseModel model = ShortcutResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> getChatInfo(int id) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.get(
        Uri.parse('$chatListUrl/$id/info'),
        headers: headers
    );

    try {
      final ChatInfoResponseModel model = ChatInfoResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true, chatInfo: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> addProvide(int id, String email) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse('$chatListUrl/$id/provide_access'),
        headers: headers,
        body: jsonEncode({
          'email': email
        })
    );

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> removeProvide(int id, String email) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse('$chatListUrl/$id/restrict_access'),
        headers: headers,
        body: jsonEncode({
          'email': email
        })
    );

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> getConnected() async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.get(Uri.parse(connectedUrl), headers: headers);

    try {
      final SettingConnectedAccountResponseModel model = SettingConnectedAccountResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, settingConnectedAccountResponse: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> addConnected(String service) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse(addConnectedUrl),
        headers: headers,
        body: jsonEncode({
          'service': service,
          'need_collect': '1'
        })
    );

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> deleteConnected(int id) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse('$connectedUrl$id/remove'),
        headers: headers
    );

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> getMyTeam() async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.get(Uri.parse(myTeamUrl), headers: headers);

    try {
      final SettingMyTeamResponseModel model = SettingMyTeamResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, settingMyTeamResponseModel: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> addMyTeam(String email, int accessSelected) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse('$myTeamUrl/invite'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'full_access': accessSelected
        })
    );

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> deleteMyTeam(String email) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse('$myTeamUrl/restrict_access'),
        headers: headers,
        body: jsonEncode({
          'email': email
        })
    );

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> deleteShortcut(int id) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse('$shortcutsUrl/$id/remove'),
        headers: headers
    );

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> addTranscription(int id, String email) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse('$chatListUrl/$id/send_transcription'),
        headers: headers,
        body: jsonEncode({'email': email})
    );

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true, message: tr('text_success_transcription')));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> getResponders() async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.get(
        Uri.parse(respondersUrl),
        headers: headers
    );

    try {
      final AutoResponderResponseModel model = AutoResponderResponseModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true, autoResponderResponseModel: model));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> addResponder(Map<String, dynamic> body) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse(addResponderUrl),
        headers: headers,
        body: jsonEncode(body)
    );

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true, message: tr('text_success_responder')));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> removeResponder(int id) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse('$respondersUrl$id/remove'),
        headers: headers,
        body: jsonEncode({})
    );

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }

  static Future<ApiModel> updateResponder(int id, Map<String, dynamic> body) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${setting?.get('token', defaultValue: '')}'
    };

    final response = await http.post(
        Uri.parse('$respondersUrl$id/update'),
        headers: headers,
        body: jsonEncode(body)
    );

    try {
      final ApiModel model = ApiModel.fromJson(jsonDecode(response.body));

      if (model.success ?? false) {
        return getApiResponse(ApiModel(code: response.statusCode, success: true));
      } else {
        return getApiResponse(ApiModel(code: response.statusCode, success: false, error: model.message));
      }
    } catch (e) {
      return getApiResponse(ApiModel(code: response.statusCode, error: e.toString()));
    }
  }
}