import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class IosDownload {
  Future<String> downloadMedia(BuildContext context, String url, [String? location, String? fileName, Map<String, String>? headers]) async {
    await requestPermission();
    var filePath = '';

    try {
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));

      if (headers != null) {
        request.headers.addAll(headers);
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == HttpStatus.ok) {
        final Uint8List bytes = await response.stream.toBytes();

          if (location == null || location == '') {
            Directory documents = await getApplicationDocumentsDirectory();
            int lastSlashIndex = url.lastIndexOf('/');
            String fileNameWithExtension = url.substring(lastSlashIndex + 1);
            int dotIndex = fileNameWithExtension.lastIndexOf('.');
            final fileExtension = url
                .toString()
                .substring(url.toString().toLowerCase().length - 3);
            String nameWithoutExtension =
                fileName ?? fileNameWithExtension.substring(0, dotIndex);
            final File file =
            File('${documents.path}/$nameWithoutExtension.$fileExtension');
            await file.writeAsBytes(bytes);
            await showCustomNotification('File Download', nameWithoutExtension);
            await openMediaFile(file.path);
            if (kDebugMode) {
              print('PDF Downloaded successfully. Path: ${file.path}');
            }
            filePath = file.path;
          } else {
            int lastSlashIndex = url.lastIndexOf('/');
            String fileNameWithExtension = url.substring(lastSlashIndex + 1);
            int dotIndex = fileNameWithExtension.lastIndexOf('.');
            final fileExtension = url
                .toString()
                .substring(url.toString().toLowerCase().length - 3);
            String nameWithoutExtension =
                fileName ?? fileNameWithExtension.substring(0, dotIndex);
            final File file =
            File('$location/$nameWithoutExtension.$fileExtension');
            await file.writeAsBytes(bytes);
            await showCustomNotification('File Download', nameWithoutExtension);
            await openMediaFile(file.path);
            if (kDebugMode) {
              print('PDF Downloaded successfully. Path: ${file.path}');
            }
            filePath = file.path;
          }
      } else {
        if (kDebugMode) {
          print('API Request failed with status ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }

    return filePath;
  }

  Future<void> openMediaFile(String filePath) async {
    const platform = MethodChannel('showCustomNotification');
    try {
      final result = await platform.invokeMethod('openMediaFile', {
        'filePath': filePath,
      });
      if (result) {
        if (kDebugMode) {
          print('Media file opened successfully');
        }
      } else {
        if (kDebugMode) {
          print('Failed to open media file');
        }
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error opening media file: ${e.message}');
      }
    }
  }

  Future<void> requestPermission() async {
    final PermissionStatus status = await Permission.storage.request();
    final PermissionStatus notificationStatus =
    await Permission.notification.request();
    if (status.isGranted && notificationStatus.isGranted) {

    } else {

    }
  }


  ///showCustomNotification(iOS Code)
  ///
  ///This method helps to show notification in the iOS device. It will directly open the file when it is downloaded successfully.

  Future<void> showCustomNotification(
      String titleMessage, String bodyMessage) async {
    const platform = MethodChannel('showCustomNotification');
    try {
      await platform.invokeMethod('showCustomNotification',
          {'title': titleMessage, 'body': bodyMessage});
    } catch (e) {
      if (kDebugMode) {
        print("Error invoking native method: $e");
      }
    }
  }


}