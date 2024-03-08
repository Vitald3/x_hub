import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import 'package:x_hub/views/chat/add_shortcuts_view.dart';
import 'package:get/route_manager.dart';
import '../../models/shortcuts_response_model.dart';
import '../../other/extensions.dart';
import '../../provider/setting_shortcut_provider.dart';

class SettingShortcutView extends StatefulWidget {
  const SettingShortcutView({super.key, this.back});

  final bool? back;

  @override
  State<SettingShortcutView> createState() => _SettingShortcutViewState();
}

class _SettingShortcutViewState extends State<SettingShortcutView> {

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await Provider.of<SettingShortcutProvider>(Get.context!, listen: false).getShortcuts();
  }

  @override
  void dispose() {
    Provider.of<SettingShortcutProvider>(Get.context!, listen: false).resetParams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - 60;

    return Consumer<SettingShortcutProvider>(
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
                              Text(
                                widget.back != null ? 'back' : 'text_setting',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                              ).tr(),
                            ],
                          ),
                        ),
                        const Text(
                          'text_shortcuts',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                        ).tr(),
                        Container(
                            alignment: Alignment.centerRight,
                            width: 50,
                            child: InkWell(
                              onTap: () {
                                provider.setSubmit(false);
                                showModalBottomSheet(context: context, backgroundColor: Colors.white, isScrollControlled: true, builder: (context) {
                                  return const AddShortcutsView();
                                }).then((value) => provider.getShortcuts());
                              },
                              child: const Icon(Icons.add),
                            )
                        )
                      ],
                    )
                ),
              ),
              body: SafeArea(
                  child: Container(
                      alignment: provider.shortcuts.isNotEmpty ? Alignment.topLeft : Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: provider.isLoader ? provider.shortcuts.isNotEmpty ? ListView.separated(
                        itemCount: provider.shortcuts.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(thickness: .1);
                        },
                        itemBuilder: (context, index) {
                          final ShortcutsModel shortcut = provider.shortcuts[index];

                          return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Slidable(
                                  key: const ValueKey(1),
                                  endActionPane: ActionPane(
                                    dragDismissible: false,
                                    extentRatio: 0.20,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                          onPressed: (BuildContext context) {
                                            snackBar(text: tr('text_remove_connected'), title: tr('text_alert'), next: tr('text_delete'), callback: () {
                                              provider.deleteShortcut(shortcut.id!).then((value) => Get.back());
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
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '/${shortcut.shortcut}',
                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50))
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      overflow: TextOverflow.ellipsis,
                                                      (shortcut.text ?? '').trim(),
                                                      style: const TextStyle(fontSize: 14, color: Color(0xFF2c3e50)),
                                                      maxLines: 3
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onTap: () {
                                                showModalBottomSheet(context: Get.context!, backgroundColor: Colors.white, isScrollControlled: true, builder: (context) {
                                                  return AddShortcutsView(edit: shortcut);
                                                }).then((value) {
                                                  provider.getShortcuts();
                                                });
                                              },
                                              child: const Icon(Icons.edit, color: primaryColor),
                                            )
                                          ],
                                        ),
                                        Transform.translate(
                                            offset: const Offset(5, 0),
                                            child: Container(width: 6, height: 30, color: Colors.white)
                                        )
                                      ]
                                  )
                              )
                          );
                        },
                      ) : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Text(
                            'text_shortcut_empty',
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