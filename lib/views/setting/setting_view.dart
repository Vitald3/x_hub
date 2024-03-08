import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x_hub/other/constant.dart';
import 'package:x_hub/views/profile_view.dart';
import 'package:x_hub/views/setting/setting_change_password.dart';
import 'package:x_hub/views/setting/setting_connected_account_view.dart';
import 'package:x_hub/views/setting/setting_my_team_view.dart';
import 'package:x_hub/views/setting/setting_shortcut_view.dart';
import '../../../provider/chat_list_provider.dart';
import '../../main.dart';
import '../../provider/main_layout_provider.dart';
import '../bottom_navigation_view.dart';
import '../login_view.dart';
import '../notification_view.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {

  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - 158;

    return Consumer<ChatListProvider>(
        builder: (context, provider, _) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                  child: ColoredBox(
                      color: Colors.white,
                      child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              elevation: 0.5,
                              backgroundColor: Colors.white,
                              titleSpacing: 0,
                              scrolledUnderElevation: 0,
                              expandedHeight: 60,
                              floating: true,
                              flexibleSpace: FlexibleSpaceBar(
                                  collapseMode: CollapseMode.pin,
                                  background: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: const Text(
                                      'text_setting',
                                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                                    ).tr(),
                                  )
                              ),
                              bottom: const PreferredSize(
                                preferredSize: Size.fromHeight(0.0),
                                child: Divider(thickness: .3),
                              ),
                            ),
                            SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                              return SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: SizedBox(
                                  height: height,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 15),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                Get.context!,
                                                CupertinoPageRoute(builder: (_) => const SettingConnectedAccountView()),
                                              );
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(left: 15, right: 8, top: 8, bottom: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: const Color(0xFF2c3e50), width: 1),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'text_connected_account',
                                                      style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                                                    ).tr(),
                                                    const Icon(Icons.arrow_forward_ios, size: 15)
                                                  ],
                                                )
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                Get.context!,
                                                CupertinoPageRoute(builder: (_) => const SettingMyTeamView()),
                                              );
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(left: 15, right: 8, top: 8, bottom: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: const Color(0xFF2c3e50), width: 1),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'text_my_team',
                                                      style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                                                    ).tr(),
                                                    const Icon(Icons.arrow_forward_ios, size: 15)
                                                  ],
                                                )
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                Get.context!,
                                                CupertinoPageRoute(builder: (_) => const SettingShortcutView()),
                                              );
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(left: 15, right: 8, top: 8, bottom: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: const Color(0xFF2c3e50), width: 1),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'text_shortcuts',
                                                      style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                                                    ).tr(),
                                                    const Icon(Icons.arrow_forward_ios, size: 15)
                                                  ],
                                                )
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                Get.context!,
                                                CupertinoPageRoute(builder: (_) => const NotificationView()),
                                              );
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(left: 15, right: 8, top: 8, bottom: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: const Color(0xFF2c3e50), width: 1),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'text_notifications',
                                                      style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                                                    ).tr(),
                                                    const Icon(Icons.arrow_forward_ios, size: 15)
                                                  ],
                                                )
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                Get.context!,
                                                CupertinoPageRoute(builder: (_) => const ProfileView()),
                                              );
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(left: 15, right: 8, top: 8, bottom: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: const Color(0xFF2c3e50), width: 1),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'text_profile',
                                                      style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                                                    ).tr(),
                                                    const Icon(Icons.arrow_forward_ios, size: 15)
                                                  ],
                                                )
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                Get.context!,
                                                CupertinoPageRoute(builder: (_) => const SettingChangePasswordView()),
                                              );
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(left: 15, right: 8, top: 8, bottom: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: const Color(0xFF2c3e50), width: 1),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text(
                                                    'text_change_pas',
                                                    style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                                                  ).tr(),
                                                  const Icon(Icons.arrow_forward_ios, size: 15)
                                                ],
                                              )
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          InkWell(
                                            onTap: () {
                                              setting?.delete('token');
                                              Provider.of<MainLayoutProvider>(context, listen: false).onItemTapped(0);
                                              Get.offAll(() => const LoginView());
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(left: 15, right: 8, top: 8, bottom: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: const Color(0xFF2c3e50), width: 1),
                                              ),
                                              child: const Text(
                                                'text_logout',
                                                style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                                              ).tr(),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap: () async {
                                          final Uri emailLaunchUri = Uri(
                                              scheme: 'mailto',
                                              path: "support@xhub.biz"
                                          );

                                          if (await canLaunchUrl(emailLaunchUri)) {
                                            await launchUrl(emailLaunchUri);
                                          } else {
                                            await Clipboard.setData(const ClipboardData(text: "support@xhub.biz"));

                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                behavior: SnackBarBehavior.floating,
                                                content: Text("text_copy"),
                                              ));
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(left: 15, right: 8, top: 8, bottom: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: removeColor, width: 1),
                                          ),
                                          child: const Text(
                                            'delete',
                                            style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                                          ).tr(),
                                        ),
                                      )
                                    ],
                                  )
                                )
                              );
                            }, childCount: 1))
                          ]
                      )
                  )
              ),
              bottomNavigationBar: const BottomNavigationView()
          );
        }
    );
  }
}