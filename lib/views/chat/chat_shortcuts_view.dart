import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import 'package:x_hub/views/setting/setting_shortcut_view.dart';
import '../../models/shortcuts_response_model.dart';
import '../../provider/chat_provider.dart';
import '../../provider/chat_shortcuts_provider.dart';

class ChatShortcutsView extends StatelessWidget {
  const ChatShortcutsView({super.key, required bool? chat});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Consumer<ChatShortcutsProvider>(builder: (context, provider, _) {
      return Wrap(
        children: [
          Container(
              height: provider.shortcuts.isNotEmpty ? height/2 : null,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: const Text(
                          'text_shortcuts',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                        ).tr(),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (_) => const SettingShortcutView(back: true)),
                            ).then((value) => provider.getShortcuts());
                          },
                          child: const Text(
                            'text_manage',
                            style: TextStyle(fontSize: 16, color: primaryColor),
                          ).tr(),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  provider.shortcuts.isNotEmpty ? Expanded(
                    child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.shortcuts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ShortcutsModel shortcut = provider.shortcuts[index];

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                                    chatProvider.textEditingController.text = shortcut.text ?? '';
                                    Navigator.of(context).pop();
                                  },
                                  child: Text.rich(
                                    TextSpan(
                                      style: const TextStyle(
                                          color: secondColor,
                                          decorationColor: Colors.transparent,
                                          decoration: TextDecoration.none,
                                          decorationStyle: TextDecorationStyle.solid
                                      ),
                                      children: [
                                        TextSpan(
                                            recognizer: TapGestureRecognizer()..onTap = () {
                                              final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                                              chatProvider.textEditingController.text = (shortcut.text ?? '').trim();
                                              Navigator.of(context).pop();
                                            },
                                            text: '/${shortcut.shortcut}  ',
                                            style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 14)
                                        ),
                                        TextSpan(text: shortcut.text, style: const TextStyle(color: Color(0xFF2c3e50), fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }, separatorBuilder: (BuildContext context, int index) {
                      return const Divider(thickness: .1);
                    })
                  ) :
                  const Text(
                      'text_shortcut_empty',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)
                  ).tr()
                ],
              )
          )
        ],
      );
    });
  }
}