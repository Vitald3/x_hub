import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/extensions.dart';
import 'package:x_hub/provider/add_shortcut_provider.dart';
import 'package:x_hub/provider/chat_info_provider.dart';
import 'package:x_hub/provider/chat_list_provider.dart';
import 'package:x_hub/provider/chat_provider.dart';
import 'package:x_hub/provider/chat_row_provider.dart';
import 'package:x_hub/provider/chat_shortcuts_provider.dart';
import 'package:x_hub/provider/chat_transcription_provider.dart';
import 'package:x_hub/provider/confirmation_provider.dart';
import 'package:x_hub/provider/filters_provider.dart';
import 'package:x_hub/provider/login_provider.dart';
import 'package:x_hub/provider/main_layout_provider.dart';
import 'package:x_hub/provider/notification_provider.dart';
import 'package:x_hub/provider/profile_provider.dart';
import 'package:x_hub/provider/register_provider.dart';
import 'package:x_hub/provider/reset_provider.dart';
import 'package:x_hub/provider/responder_edit_provider.dart';
import 'package:x_hub/provider/responder_provider.dart';
import 'package:x_hub/provider/setting_change_password.dart';
import 'package:x_hub/provider/setting_connected_account_provider.dart';
import 'package:x_hub/provider/setting_my_team_provider.dart';
import 'package:x_hub/provider/setting_shortcut_provider.dart';
import 'package:x_hub/services/notification_service.dart';
import 'package:x_hub/views/login_view.dart';
import 'package:x_hub/views/main_layout.dart';
import 'package:x_hub/views/register_view.dart';
import 'package:x_hub/views/reset_view.dart';
import 'other/constant.dart';

String token = '';
Box? setting;
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Hive.initFlutter();
  setting = await Hive.openBox('setting');
  token = setting?.get('token', defaultValue: '');
  await NotificationService().init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => MainLayoutProvider()),
      ChangeNotifierProvider(create: (context) => LoginProvider()),
      ChangeNotifierProvider(create: (context) => RegisterProvider()),
      ChangeNotifierProvider(create: (context) => ChatListProvider()),
      ChangeNotifierProvider(create: (context) => ChatProvider()),
      ChangeNotifierProvider(create: (context) => FiltersProvider()),
      ChangeNotifierProvider(create: (context) => ChatRowProvider()),
      ChangeNotifierProvider(create: (context) => AddShortcutProvider()),
      ChangeNotifierProvider(create: (context) => ChatShortcutsProvider()),
      ChangeNotifierProvider(create: (context) => ChatInfoProvider()),
      ChangeNotifierProvider(create: (context) => SettingConnectedAccountProvider()),
      ChangeNotifierProvider(create: (context) => SettingMyTeamProvider()),
      ChangeNotifierProvider(create: (context) => SettingShortcutProvider()),
      ChangeNotifierProvider(create: (context) => ChatTranscriptionProvider()),
      ChangeNotifierProvider(create: (context) => ResponderProvider()),
      ChangeNotifierProvider(create: (context) => ResponderEditProvider()),
      ChangeNotifierProvider(create: (context) => ConfirmationProvider()),
      ChangeNotifierProvider(create: (context) => ResetProvider()),
      ChangeNotifierProvider(create: (context) => SettingChangePasswordProvider()),
      ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ChangeNotifierProvider(create: (context) => NotificationProvider())
    ],
    child: EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('pl')],
      path: 'assets/translations',
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      child: const App(),
    ),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      color: Colors.white,
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
            child: child!
        );
      },
      initialRoute: token != '' ? '/' : 'login',
      routes: {
        'login': (_) => const LoginView(),
        'reset': (_) => const ResetView(),
        'register': (_) => const RegisterView(),
        '/': (_) => MainLayoutView()
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case 'login':
            return CupertinoPageRoute(builder: (_) => const LoginView(), settings: settings);
          case 'reset':
            return CupertinoPageRoute(builder: (_) => const ResetView(), settings: settings);
          case 'register':
            return CupertinoPageRoute(builder: (_) => const RegisterView(), settings: settings);
          case '/':
            return CupertinoPageRoute(builder: (_) => MainLayoutView(), settings: settings);
          default:
            return CupertinoPageRoute(builder: (_) => const LoginView(), settings: settings);
        }
      },
      onUnknownRoute: (settings) => CupertinoPageRoute(
          builder: (context) {
            return MainLayoutView();
          }
      ),
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primarySwatch: secondColor.asMaterialColor,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: primaryColor,
          selectionHandleColor: primaryColor
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: secondColor),
          displayMedium: TextStyle(color: secondColor),
          bodyMedium: TextStyle(color: secondColor),
          titleMedium: TextStyle(color: secondColor),
        ),
      ),
    );
  }
}