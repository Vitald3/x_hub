import 'package:get/route_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import '../models/user_response_model.dart';
import '../provider/notification_provider.dart';

class NotificationRowView extends StatefulWidget {
  const NotificationRowView({super.key, required this.item});

  final UserNotifications item;

  @override
  State<NotificationRowView> createState() => _NotificationRowViewState();
}

class _NotificationRowViewState extends State<NotificationRowView> {
  bool toggle = false;

  @override
  void initState() {
    toggle = widget.item.state == 1 ? true : false;
    super.initState();
  }

  void setToggle(bool val) {
    setState(() {
      toggle = val;
    });

    Provider.of<NotificationProvider>(Get.context!, listen: false).confirm(widget.item, toggle);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.item.name!,
            style: const TextStyle(
                color: secondColor,
                fontSize: 14,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(6, 0),
          child: Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                activeColor: primaryColor,
                thumbColor: Colors.white,
                trackColor: const Color(0xFF979797),
                value: toggle,
                onChanged: (value) => setToggle(value),
              )
          )
        )
      ],
    );
  }
}