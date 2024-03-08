import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import 'package:x_hub/other/extensions.dart';
import '../../provider/chat_info_provider.dart';

class ChatAddProvideView extends StatelessWidget {
  const ChatAddProvideView({super.key, required this.id, required this.access});

  final int id;
  final List<String> access;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var accessEdit = <String>[];

    if (access.length == 1) {
      accessEdit.add(tr('text_select'));

      for (var i in access) {
        accessEdit.add(i);
      }
    } else {
      for (var i in access) {
        accessEdit.add(i);
      }
    }

    return Consumer<ChatInfoProvider>(builder: (context, provider, _) {
      return Wrap(
        children: [
          Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'text_share_conversation',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                  ).tr(),
                  const SizedBox(height: 20),
                  accessEdit.isNotEmpty ? DropdownButton<String>(
                    isExpanded: true,
                    value: provider.accessSelected == '' ? null : provider.accessSelected,
                    icon: const Icon(Icons.arrow_drop_down),
                    hint: const Text(
                      'text_select',
                      style: TextStyle(fontSize: 13, color: Color(0xFF2c3e50)),
                    ).tr(),
                    style: const TextStyle(color: Color(0xFF2c3e50)),
                    onChanged: (String? value) {
                      provider.setAccessSelected(value!);
                    },
                    items: accessEdit.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ) : const Text(
                    'text_share_conversation_empty',
                    style: TextStyle(fontSize: 14, color: Color(0xFF2c3e50)),
                  ).tr(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2c3e50),
                            elevation: 0,
                            minimumSize: Size(accessEdit.isNotEmpty ? (width/2)-23 : width-30, 38)
                        ),
                        child: Text(
                          accessEdit.isNotEmpty ? 'text_reset' : 'back',
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                        ).tr(),
                      ),
                      if (accessEdit.isNotEmpty) ElevatedButton(
                        onPressed: () {
                          if (provider.accessSelected == '') {
                            snackBar(text: tr('text_error_share'), error: true);
                          } else {
                            provider.addProvide(id, provider.accessSelected).then((value) {
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0,
                            minimumSize: Size((width/2)-23, 38)
                        ),
                        child: !provider.submit ? const Text(
                          'text_submit',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ).tr() : const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white)
                        )
                      ),
                    ],
                  )
                ],
              )
          )
        ],
      );
    });
  }
}