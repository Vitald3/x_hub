import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import '../../provider/setting_connected_account_provider.dart';

class SettingConnectedBottomSheetView extends StatelessWidget {
  const SettingConnectedBottomSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer<SettingConnectedAccountProvider>(builder: (context, provider, _) {
      return Wrap(
        children: [
          Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'text_add_new',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                  ).tr(),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 0,
                    horizontalTitleGap: -15,
                    title: const Text(
                      'text_add_allegro',
                      style: TextStyle(fontSize: 14, color: Color(0xFF2c3e50)),
                    ).tr(),
                    onTap: () {
                      provider.setSelected(1);
                    },
                    leading: Transform.translate(
                      offset: const Offset(-15, 0),
                      child: Radio(
                        activeColor: primaryColor,
                        value: 1,
                        groupValue: provider.selectedOption,
                        onChanged: (val) {
                          provider.setSelected(val!);
                        },
                      ),
                    )
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 0,
                    horizontalTitleGap: -15,
                    onTap: () {
                      provider.setSelected(2);
                    },
                    title: const Text(
                      'text_add_olx',
                      style: TextStyle(fontSize: 14, color: Color(0xFF2c3e50)),
                    ).tr(),
                    leading: Transform.translate(
                      offset: const Offset(-15, 0),
                      child: Radio(
                        activeColor: primaryColor,
                        value: 2,
                        groupValue: provider.selectedOption,
                        onChanged: (val) {
                          provider.setSelected(val!);
                        },
                      ),
                    )
                  ),
                  const SizedBox(height: 8),
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
                            minimumSize: Size((width/2)-23, 38)
                        ),
                        child: const Text(
                          'text_cancel',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ).tr(),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          provider.addConnected().then((value) => Navigator.of(context).pop());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0,
                            minimumSize: Size((width/2)-23, 38)
                        ),
                        child: !provider.submit ? const Text(
                          'text_add',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ).tr() : const SizedBox(
                            width: 24,
                            height: 24,
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