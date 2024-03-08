import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:x_hub/views/main_layout.dart';
import '../views/chat/chat_view.dart';
import '../views/setting/setting_connected_account_view.dart';
import '../views/setting/setting_my_team_view.dart';
import 'firebase_options.dart';
import 'package:get/route_manager.dart';
import 'dart:io' show Platform;
import 'package:x_hub/main.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  static var fireBaseToken = "";

  factory NotificationService() {
    return _notificationService;
  }

  String getToken() {
    return fireBaseToken;
  }

  NotificationService._internal();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'xHub',
      'xHub',
      description: 'This channel is used for important notifications.',
      playSound: true,
      importance: Importance.high
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    if (Platform.isIOS) {
      fireBaseToken = await FirebaseMessaging.instance.getAPNSToken() ?? "";
    } else {
      fireBaseToken = await FirebaseMessaging.instance.getToken() ?? "";
    }

    setting?.put('f_token', fireBaseToken);
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onSelectNotification);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showNotifications(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      nav(message.data);
    });
  }

  void nav(Map<String, dynamic> data) {
    if (data['chat'] != null && int.tryParse(data['chat']) != null) {
      Navigator.push(
        Get.context!,
        CupertinoPageRoute(builder: (_) => ChatView(id: int.parse(data['chat']))),
      );
    } else if (data['display'] != null && int.tryParse(data['display']) != null) {
      switch (int.parse(data['display'])) {
        case 1:
          Navigator.push(
            Get.context!,
            CupertinoPageRoute(builder: (_) => MainLayoutView(index: 1)),
          );

          break;
        case 2:
          Navigator.push(
            Get.context!,
            CupertinoPageRoute(builder: (_) => const SettingConnectedAccountView()),
          );

          break;
        case 3:
          Navigator.push(
            Get.context!,
            CupertinoPageRoute(builder: (_) => const SettingMyTeamView()),
          );

          break;
      }
    }
  }

  Future? onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    if (payload != null && payload != "") {
      var payloadData = jsonDecode(payload);
      nav(payloadData);
    }

    return null;
  }

  Future? onSelectNotification(NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null && notificationResponse.payload != "") {
      var payloadData = jsonDecode(notificationResponse.payload!);
      nav(payloadData);
    }
  }

  Future<void> showNotifications(RemoteMessage message) async {
    Random random = Random();
    int id = random.nextInt(900) + 10;

    await flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: "@mipmap/ic_launcher",
              channelShowBadge: true,
              playSound: true,
              priority: Priority.high,
              importance: Importance.high,
              styleInformation: BigTextStyleInformation(message.notification!.body!),
            ),

            iOS: const DarwinNotificationDetails(
              presentBadge: true,
              presentSound: true,
              presentAlert: true,
              badgeNumber: 1,
            )
        ),
        payload: jsonEncode(message.data)
    );
  }
}