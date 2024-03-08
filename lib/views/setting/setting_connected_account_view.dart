import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import 'package:x_hub/views/setting/setting_connected_bottom_sheet_view.dart';
import 'package:get/route_manager.dart';
import '../../models/setting_connected_account_response_model.dart';
import '../../other/extensions.dart';
import '../../provider/setting_connected_account_provider.dart';

class SettingConnectedAccountView extends StatefulWidget {
  const SettingConnectedAccountView({super.key});

  @override
  State<SettingConnectedAccountView> createState() => _SettingConnectedAccountViewState();
}

class _SettingConnectedAccountViewState extends State<SettingConnectedAccountView> {

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await Provider.of<SettingConnectedAccountProvider>(Get.context!, listen: false).getConnected();
  }

  @override
  void dispose() {
    Provider.of<SettingConnectedAccountProvider>(Get.context!, listen: false).resetParams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - 60;

    return Consumer<SettingConnectedAccountProvider>(
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
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          'text_connected_account',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                        ).tr(),
                        Container(
                            alignment: Alignment.centerRight,
                            width: 50,
                            child: InkWell(
                              onTap: () {
                                provider.setSubmit(false);
                                showModalBottomSheet(context: context, backgroundColor: Colors.white, isScrollControlled: true, builder: (context) {
                                  return const SettingConnectedBottomSheetView();
                                });
                              },
                              child: const Icon(Icons.add),
                            )
                        )
                      ],
                    )
                ),
              ),
              body: SafeArea(
                  top: true,
                  child: Container(
                      alignment: provider.connectedAccounts.isNotEmpty ? Alignment.topLeft : Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: provider.isLoader ? provider.connectedAccounts.isNotEmpty ? ListView.separated(
                        itemCount: provider.connectedAccounts.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(thickness: .1);
                        },
                        itemBuilder: (context, index) {
                          final ConnectedAccount connected = provider.connectedAccounts[index];

                          Color color;

                          if (connected.service == 'allergo' || connected.service == 'allegro') {
                            color = const Color(0xFFe67e22);
                          } else if (connected.service == 'olx') {
                            color = const Color(0xFF16a085);
                          } else {
                            color = primaryColor;
                          }

                          double width = textSize(connected.username ?? '', const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 9)).width + (connected.service == 'allergo' || connected.service == 'allegro' ? 30 : 20);

                          if (width > 82) {
                            width = 82;
                          }

                          return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Slidable(
                                  key: const ValueKey(1),
                                  endActionPane: ActionPane(
                                    dragDismissible: false,
                                    extentRatio: 0.2,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (BuildContext context) {
                                          snackBar(text: tr('text_remove_connected'), title: tr('text_alert'), next: tr('text_delete'), prev: true, callback: () {
                                            provider.deleteConnected(connected.id!).then((value) => Get.back());
                                          });
                                        },
                                        backgroundColor: removeColor,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: width,
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                  decoration: BoxDecoration(
                                                      color: color,
                                                      borderRadius: const BorderRadius.all(Radius.circular(10))
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      if (connected.service!.contains('allegro') || connected.service == 'olx' || connected.service == 'allergo') SvgPicture.asset('assets/images/${connected.service!.contains('allegro') ? 'allergo' : connected.service}.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), semanticsLabel: connected.service, width: 18, height: 15),
                                                      if (connected.username != null) Expanded(
                                                        child: Text('  ${connected.username ?? ''}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 9), overflow: TextOverflow.ellipsis)
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'text_created',
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2c3e50)),
                                                    ).tr(),
                                                    Text(
                                                      readTimestamp(connected.createdAt!, formatStr: 'dd.MM.yyyy'),
                                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2c3e50)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          connected.status == 0 && connected.authLink != null ? ElevatedButton(
                                              onPressed: () {
                                                provider.openWeb(connected.authLink!);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: primaryColor,
                                                  elevation: 0,
                                                  minimumSize: const Size(60, 30)
                                              ),
                                              child: const Text(
                                                'text_auth',
                                                style: TextStyle(fontSize: 14, color: Colors.white),
                                              ).tr()
                                          ) : Text(
                                            connected.status == 1 ? 'text_prepare' : 'text_active',
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2c3e50)),
                                          ).tr()
                                        ],
                                      ),
                                      Transform.translate(
                                        offset: const Offset(6, 0),
                                        child: Container(width: 6, height: 60, color: Colors.white)
                                      )
                                    ],
                                  )
                              )
                          );
                        },
                      ) : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Text(
                              'text_account_empty',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)
                          ).tr()
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
          );
        }
    );
  }
}