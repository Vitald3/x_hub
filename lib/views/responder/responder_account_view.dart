import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import '../../models/setting_connected_account_response_model.dart';
import '../../provider/chat_transcription_provider.dart';
import '../../provider/responder_edit_provider.dart';
import 'checkbox_view.dart';

class ResponderAccountsView extends StatelessWidget {
  const ResponderAccountsView({super.key, required this.connected});

  final List<ConnectedAccount> connected;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer<ChatTranscriptionProvider>(builder: (context, provider, _) {
      return SafeArea(
          child: Wrap(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: MediaQuery.of(context).viewInsets.bottom + 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'text_for_accounts',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                      ).tr(),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: connected.length > 9 ? 300 : connected.length * 30,
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: connected.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CheckboxView(label: '${connected[index].service!}: ${connected[index].owner!}', value: connected[index].id!);
                            }, separatorBuilder: (BuildContext context, int index) {
                          return const Divider(thickness: .1);
                        }),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Provider.of<ResponderEditProvider>(context, listen: false).setConnectors([]);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2c3e50),
                                elevation: 0,
                                minimumSize: Size((width/2)-23, 38)
                            ),
                            child: const Text(
                              'text_reset',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ).tr(),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                Provider.of<ResponderEditProvider>(context, listen: false).update();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  elevation: 0,
                                  minimumSize: Size((width/2)-23, 38)
                              ),
                              child: !provider.submit ? const Text(
                                'next',
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
          )
      );
    });
  }
}