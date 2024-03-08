import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import 'package:get/route_manager.dart';
import '../main.dart';
import '../models/api_model.dart';
import 'dart:io';

import '../provider/main_layout_provider.dart';
import '../views/login_view.dart';
import '../views/main_layout.dart';

extension ToMaterialColor on Color {
  MaterialColor get asMaterialColor {
    Map<int, Color> shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]
        .asMap()
        .map((key, value) => MapEntry(value, withOpacity(1 - (1 - (key + 1) / 10))));

    return MaterialColor(value, shades);
  }
}

Future<String?> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor;
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id;
  } else {
    return '';
  }
}

class EmptyBox extends StatelessWidget {
  const EmptyBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 0, height: 0);
  }
}

Size textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

ApiModel getApiResponse(ApiModel model) {
  if (model.error != null) {
    snackBar(error: true, text: model.error ?? tr('error'));

    if (model.code == 401 && setting?.get('token', defaultValue: '') != '') {
      setting?.delete('token');
      Provider.of<MainLayoutProvider>(Get.context!, listen: false).onItemTapped(0);
      Navigator.pushAndRemoveUntil(
          Get.context!,
          CupertinoPageRoute(builder: (BuildContext context) => const LoginView()),
              (Route<dynamic> route) => route is MainLayoutView
      );
    }
  } else if ((model.success ?? false) && model.message != null) {
    snackBar(text: model.message!, title: tr('success'));
  } else {
    switch (model.code) {
      case 403:
      case 409:
      case 500:
        snackBar(error: true, text: model.message != null ? model.message! : tr('server_error'));
        break;
      case 401:
        setting?.delete('token');
        Provider.of<MainLayoutProvider>(Get.context!, listen: false).onItemTapped(0);
        Navigator.pushAndRemoveUntil(
            Get.context!,
            CupertinoPageRoute(builder: (BuildContext context) => const LoginView()),
                (Route<dynamic> route) => route is MainLayoutView
        );
        break;
      case 429:
        snackBar(error: true, text: model.message != null ? model.message! : tr('server_error'));
        break;
    }
  }

  return model;
}

List<TextSpan> highlightOccurrences(String source, String query) {
  if (query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
    return [ TextSpan(text: source) ];
  }
  final matches = query.toLowerCase().allMatches(source.toLowerCase());

  int lastMatchEnd = 0;

  final List<TextSpan> children = [];
  for (var i = 0; i < matches.length; i++) {
    final match = matches.elementAt(i);

    if (match.start != lastMatchEnd) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, match.start),
      ));
    }

    children.add(TextSpan(
      text: source.substring(match.start, match.end),
      style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
    ));

    if (i == matches.length - 1 && match.end != source.length) {
      children.add(TextSpan(
        text: source.substring(match.end, source.length),
      ));
    }

    lastMatchEnd = match.end;
  }
  return children;
}

void snackBar({String text = '', String title = '', bool error = false, bool prev = false, Function? callback, String next = 'next'}) {
  showDialog(context: Get.context!, builder: (_) {
    return CupertinoAlertDialog(
      title: Text(error ? tr('error') : (title != '' ? title : tr('success'))),
      actions: [
        if (prev) CupertinoDialogAction(onPressed: () {
          Get.back();
        }, child: const Text('text_cancel', style: TextStyle(color: primaryColor)).tr()),
        CupertinoDialogAction(onPressed: () {
          if (callback != null) {
            callback();
          } else {
            Get.back();
          }
        }, child: Text(next, style: const TextStyle(color: primaryColor)).tr()),
      ],
      content: Text(text),
    );
  });
}

String getNoun(int number, String one, String two, String three) {
  var n = number.abs();
  n %= 100;
  if (n >= 5 && n <= 20) {
    return "$number $three";
  }
  n %= 10;
  if (n == 1) {
    return "$number $one";
  }
  if (n >= 2 && n <= 4) {
    return "$number $two";
  }
  return "$number $three";
}

String readTimestamp(int timestamp, {String formatStr = 'dd.MM'}) {
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var format2 = DateFormat(formatStr);
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    time = format2.format(date);
  } else {
    time = format2.format(date);
  }

  return time.replaceAll(' AM', '').replaceAll(' PM', '');
}