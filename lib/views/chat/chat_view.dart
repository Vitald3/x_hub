import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/views/chat/receiver_row_view.dart';
import 'package:x_hub/views/chat/sender_row_view.dart';
import 'package:get/route_manager.dart';
import '../../other/constant.dart';
import '../../provider/chat_provider.dart';
import '../../provider/chat_shortcuts_provider.dart';
import 'chat_info_view.dart';
import 'chat_shortcuts_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.id, this.before});

  final int id;
  final int? before;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    final provider = Provider.of<ChatProvider>(Get.context!, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.resetParams();
    });
    provider.scrollListener(widget.id);
    await getChat(widget.id, widget.before);
    Provider.of<ChatShortcutsProvider>(Get.context!, listen: false).getShortcuts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(Get.context!, listen: false).textEditingController.clear();
      Provider.of<ChatProvider>(Get.context!, listen: false).resetParams();
    });
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  Future<void> getChat(int id, int? before) async {
    final provider = Provider.of<ChatProvider>(Get.context!, listen: false);
    await provider.getChat(id, before: before);

    if ((widget.before != null && timer == null && !provider.timerStop && provider.qtyBefore + provider.offsetChatBottom >= provider.total) || widget.before == null) {
      provider.setTimerStop(false);

      timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (!provider.timerStop) {
          provider.getChat(id, before: before, timer: true);
        } else {
          timer.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - 60;

    return Consumer<ChatProvider>(builder: (context, provider, _) {
      return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  scrolledUnderElevation: 0,
                  toolbarHeight: provider.conversation.title != null ? 86 : 46,
                  elevation: 0,
                  title: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (provider.chat.isNotEmpty) SizedBox(
                                width: 190,
                                child: GestureDetector(
                                  onTap: () {
                                    provider.setTimerStop(true);
                                    timer?.cancel();
                                    timer = null;

                                    Navigator.push(
                                      Get.context!,
                                      CupertinoPageRoute(builder: (_) => ChatInfoView(id: widget.id, name: provider.conversation.createdBy ?? '', service: provider.conversation.service!, serviceLogin: provider.conversation.serviceLogin!)),
                                    ).then((value) => getChat(widget.id, widget.before));
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        provider.conversation.createdBy ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2c3e50),
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis
                                        ),
                                      ),
                                      Text(
                                        '${provider.conversation.service} ${provider.conversation.serviceLogin}',
                                        style: const TextStyle(
                                            color: Color(0xFF2c3e50),
                                            fontSize: 13,
                                            overflow: TextOverflow.ellipsis
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(Get.context!).pop();
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(Icons.arrow_back_ios, size: 18),
                                        const Text(
                                          'chat_list_title',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                                        ).tr(),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      provider.setTimerStop(true);
                                      timer?.cancel();
                                      timer = null;

                                      Navigator.push(
                                        Get.context!,
                                        CupertinoPageRoute(builder: (_) => ChatInfoView(id: widget.id, name: provider.conversation.createdBy ?? '', service: provider.conversation.service!, serviceLogin: provider.conversation.serviceLogin!)),
                                      ).then((value) => getChat(widget.id, widget.before));
                                    },
                                    child: SvgPicture.asset("assets/images/chat_info.svg", semanticsLabel: 'Chat info', width: 22, height: 22),
                                  ),
                                ],
                              )
                            ],
                          )
                      ),
                      const SizedBox(height: 10),
                      if (provider.conversation.title != null) Container(
                        width: double.infinity,
                        height: 40,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        color: const Color(0xFF16a085),
                        child: Text(provider.conversation.title!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      )
                    ],
                  )
              ),
              body: SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: provider.isLoader ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  reverse: true,
                                  controller: provider.scrollController,
                                  itemCount: provider.chat.length,
                                  itemBuilder: (context, index) {
                                    return provider.chat[index].youSender ?? false ? SenderRowView(chat: provider.chat[index], provider: provider) :
                                    ReceiverRowView(chat: provider.chat[index], provider: provider);
                                  }
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Wrap(
                                      children: [
                                        Stack(
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  provider.setAttachment();
                                                },
                                                child: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: provider.files != null ? const Color(0xFF2c3e50) : primaryColor,
                                                  child: const Icon(Icons.attach_file_sharp, size: 20, color: Colors.white),
                                                )
                                            ),
                                            if (provider.loadAttachment) const SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: CircularProgressIndicator(color: Colors.white)
                                            )
                                          ],
                                        ),
                                        const SizedBox(width: 4),
                                        InkWell(
                                            onTap: () {
                                              showModalBottomSheet(context: context, backgroundColor: Colors.white, builder: (context) {
                                                return const ChatShortcutsView(chat: true);
                                              });
                                            },
                                            child: const CircleAvatar(
                                              radius: 15,
                                              backgroundColor: primaryColor,
                                              child: Text('/', style: TextStyle(color: Colors.white)),
                                            )
                                        ),
                                        const SizedBox(width: 8)
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxHeight: 100,
                                        ),
                                        child: TextFormField(
                                          cursorHeight: 20,
                                          controller: provider.textEditingController,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          onChanged: (val) {
                                            if (val != '' && val[0] == '/') {
                                              provider.setShortcutsVisible(1, val);
                                            } else {
                                              provider.setShortcutsVisible(0, '');
                                            }
                                          },
                                          textInputAction: TextInputAction.newline,
                                          style: const TextStyle(color: Color(0xFF2c3e50)),
                                          decoration: InputDecoration(
                                            hintText: tr('text_write'),
                                            fillColor: const Color(0xFFecf0f1),
                                            filled: true,
                                            hintStyle: const TextStyle(
                                                color: Color(0xFF728A9D),
                                                fontSize: 12
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                            focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.transparent,
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(16))
                                            ),
                                            enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.transparent,
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: InkWell(
                                        onTap: () async {
                                          if (!provider.submit && (provider.textEditingController.text != '' || provider.files != null)) {
                                            provider.submit = true;
                                            provider.sendMessage(widget.id);
                                          }
                                        },
                                        child: Icon(Icons.send, size: 30, color: !provider.submit && (provider.textEditingController.text != '' || provider.files != null) ? primaryColor : Colors.black12),
                                      )
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        AnimatedOpacity(
                            opacity: provider.shortcuts.isEmpty ? 0 : provider.shortcutsVisible,
                            duration: const Duration(milliseconds: 600),
                            child: Container(
                                height: provider.shortcuts.isNotEmpty && provider.shortcutsVisible > 0 ? (provider.shortcuts.length > 3 ? 150 : (provider.shortcuts.length * 70)) : 1,
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.only(bottom: 60),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFF2c3e50).withOpacity(.2),
                                        blurRadius: 10,
                                        spreadRadius: .5
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                        child: ListView.separated(
                                          physics: const ClampingScrollPhysics(),
                                          itemCount: provider.shortcuts.length,
                                          itemBuilder: (context, index) => GestureDetector(
                                              onTap: () {
                                                provider.textEditingController.text = provider.shortcuts[index].text ?? '';
                                                provider.setShortcutsHide();
                                              },
                                              child: Text.rich(
                                                textAlign: TextAlign.left,
                                                TextSpan(
                                                  style: const TextStyle(
                                                      color: secondColor,
                                                      decorationColor: Colors.transparent,
                                                      decoration: TextDecoration.none,
                                                      decorationStyle: TextDecorationStyle.solid
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                        text: '/${provider.shortcuts[index].shortcut}  ',
                                                        style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 14)
                                                    ),
                                                    TextSpan(text: provider.shortcuts[index].text, style: const TextStyle(color: Color(0xFF2c3e50), fontSize: 14)),
                                                  ],
                                                ),
                                              )
                                          ), separatorBuilder: (BuildContext context, int index) { return const Divider(thickness: .1); },
                                        )
                                    )
                                  ],
                                )
                            )
                        ),
                        Visibility(
                            visible: provider.newMessage != 0.0,
                            child: InkWell(
                              onTap: () {
                                provider.setNewMessage(0.0);
                                provider.scrollAnimation();
                              },
                              child: Container(
                                  height: 20,
                                  width: 112,
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  margin: const EdgeInsets.only(bottom: 85),
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 1,
                                          spreadRadius: .2
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.white),
                                      const Text(
                                        'text_new_message',
                                        style: TextStyle(fontSize: 12, color: Colors.white),
                                      ).tr(),
                                    ],
                                  )
                              )
                            )
                        ),
                      ],
                    ) : Container(
                        alignment: Alignment.center,
                        height: height,
                        child: const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(color: primaryColor)
                        )
                    )
                  )
              )
          )
      );
    });
  }
}