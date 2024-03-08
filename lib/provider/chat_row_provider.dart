import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';
import '../services/api.dart';

class ChatRowProvider extends ChangeNotifier {

  bool getDownloaded(int id) {
    //setting?.delete('downloaded');
    final item = getItem('downloaded');
    return item != null && item['$id'] != null;
  }

  bool getDownload(int id) {
    //setting?.delete('download');
    final item = getItem('download');
    return item != null && item['$id'] != null;
  }

  void setDownload(int id) async {
    var item = getItem('download');

    if (item == null) {
      setting?.put('download', '{$id: 1}');
    } else {
      item['$id'] = 1;
      setting?.put('download', '$item');
    }

    notifyListeners();
  }

  String getDownloadedItem(int id) {
    final item = getItem('downloaded');
    return item != null && item['$id'] != null ? item['$id'].replaceAll('"', '') : '';
  }

  Map<String, dynamic>? getItem(String name) {
    final item = setting?.get(name, defaultValue: '');

    if (item != "") {
      var stringJson = removeJsonAndArray(item);

      var dataSp = stringJson.split(',');
      Map<String, dynamic> mapData = {};

      for (var element in dataSp) {
        mapData[element.split(':')[0].trim()] = element.split(':')[1].trim();
      }

      return mapData;
    }

    return null;
  }

  Future<bool> requestPermission() async {
    const permission = Permission.storage;

    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();

      if (result == PermissionStatus.granted) {
        return true;
      }
    }

    return false;
  }

  Future<bool> downloadFile(String url, String filename, int id) async {
    final downloaded = await Api.downloadFile(url, filename);

    if (downloaded != '') {
      var item = getItem('downloaded');

      if (item == null) {
        setting?.put('downloaded', '{$id: "$downloaded"}');
      } else {
        item['$id'] = downloaded;
        setting?.put('downloaded', '$item');
      }

      var item2 = getItem('download');

      if (item2 != null && item2['$id'] != null) {
        item2.forEach((key, value) {
          if (key == '$id') {
            item2.remove(key);
          }
        });

        if (item2.isNotEmpty) {
          setting?.put('download', '$item');
        } else {
          setting?.delete('download');
        }
      }

      notifyListeners();
      return downloaded != '';
    } else {
      return false;
    }
  }

  String removeJsonAndArray(String text) {
    if (text.startsWith('[') || text.startsWith('{')) {
      text = text.substring(1, text.length - 1);
      if (text.startsWith('[') || text.startsWith('{')) {
        text = removeJsonAndArray(text);
      }
    }

    return text;
  }
}