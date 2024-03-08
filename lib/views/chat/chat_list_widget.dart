import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import '../../models/chat_list_response_model.dart';
import '../../other/constant.dart';
import '../../other/extensions.dart';
import '../../provider/chat_list_provider.dart';
import 'chat_view.dart';

Widget chatListWidget(ChatListProvider provider, DataChatList chat) {
  Color color;

  if (chat.service == 'allergo' || chat.service == 'allegro') {
    color = const Color(0xFFe67e22);
  } else if (chat.service == 'olx') {
    color = const Color(0xFF16a085);
  } else {
    color = primaryColor;
  }

  double width = textSize(chat.serviceLogin ?? '', const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 9)).width + 30;

  if (width > 82) {
    width = 82;
  }

  return GestureDetector(
    onTap: () {
      provider.cancelTimer();

      Navigator.push(
        Get.context!,
        CupertinoPageRoute(builder: (_) => ChatView(id: chat.sender != null ? chat.conversationId! : chat.id!, before: chat.sender != null ? chat.createdAt! : null)),
      ).then((value) => provider.getChatList(canceled: true, reset: provider.controller.text != ''));
    },
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    chat.createdBy ?? chat.sender!,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2c3e50)
                    ),
                  ),
                )
            ),
            Row(
              children: [
                if (chat.conversationType == 'disputes') SvgPicture.asset('assets/images/1.svg', semanticsLabel: 'disputes', height: 16, colorFilter: const ColorFilter.mode(removeColor, BlendMode.srcIn)),
                if (chat.conversationType == 'disputes') const SizedBox(width: 6),
                if (chat.serviceLogin != null) Container(
                  alignment: Alignment.center,
                  width: width,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (chat.service == 'allergo' || chat.service == 'allegro' || chat.service == 'olx') SvgPicture.asset('assets/images/${chat.service}.svg', semanticsLabel: chat.service, width: 18, height: 15),
                      Expanded(
                          child: Text(chat.serviceLogin!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 9), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis)
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                chat.lastMessage != null ? Text(readTimestamp(chat.lastMessage!.createdAt!), style: const TextStyle(color: Color(0xFF2c3e50), fontSize: 12)) :
                Text(readTimestamp(chat.createdAt!), style: const TextStyle(color: Color(0xFF2c3e50), fontSize: 12))
              ],
            )
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: (chat.unread ?? 0) > 0 ? 15 : 15),
                  child: Text.rich(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    TextSpan(
                      style: const TextStyle(
                          color: secondColor,
                          decorationColor: Colors.transparent,
                          decoration: TextDecoration.none,
                          decorationStyle: TextDecorationStyle.solid
                      ),
                      children: [
                        if (chat.lastMessage?.sender != null && chat.lastMessage!.sender != '' && provider.user != null && provider.user!.email != chat.lastMessage!.sender) TextSpan(text: '${chat.lastMessage!.sender!.trim()}: ', style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 12)),
                        TextSpan(children: highlightOccurrences((chat.message != null ? chat.message! : (chat.lastMessage!.message ?? '')), Provider.of<ChatListProvider>(Get.context!, listen: false).textSearch), style: const TextStyle(color: Color(0xFF2c3e50), fontSize: 12)),
                      ],
                    ),
                  ),
                )
            ),
            Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                    color: (chat.unread ?? 0) > 0 ? primaryColor : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))
                ),
                alignment: Alignment.center,
                child: Text(chat.unread.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))
            )
          ],
        )
      ],
    ),
  );
}