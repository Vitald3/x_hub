import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import 'package:x_hub/provider/notification_provider.dart';
import 'package:get/route_manager.dart';
import '../models/user_response_model.dart';
import 'notification_row.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    Provider.of<NotificationProvider>(Get.context!, listen: false).resetParams();
    Provider.of<NotificationProvider>(Get.context!, listen: false).getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0.5,
                backgroundColor: Colors.white,
                titleSpacing: 0,
                scrolledUnderElevation: 0,
                title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_back_ios, size: 18),
                              const Text(
                                'text_setting',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                              ).tr(),
                            ],
                          ),
                        ),
                        const Text(
                          'text_notifications',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                        ).tr(),
                        const SizedBox(
                            width: 70
                        )
                      ],
                    )
                ),
              ),
              body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(children: List.generate(provider.notifications.length, (index) {
                          final UserNotifications item = provider.notifications[index];

                          return Column(
                            children: [
                              NotificationRowView(item: item),
                              if (provider.notifications.length-1 > index) const Divider(color: secondColor, thickness: .1),
                            ],
                          );
                        })),
                      ],
                    ),
                  ),
                ),
              )
          );
        }
    );
  }
}