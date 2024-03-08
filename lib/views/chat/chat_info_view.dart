import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/extensions.dart';
import 'package:x_hub/views/chat/chat_transcription_bottom_sheet_view.dart';
import '../../models/chat_info_response_model.dart';
import '../../other/constant.dart';
import '../../provider/chat_info_provider.dart';
import '../../provider/chat_row_provider.dart';
import 'chat_add_provide_view.dart';

class ChatInfoView extends StatefulWidget {
  const ChatInfoView({super.key, required this.id, required this.name, required this.service, required this.serviceLogin});

  final int id;
  final String name;
  final String service;
  final String serviceLogin;

  @override
  State<ChatInfoView> createState() => _ChatInfoViewState();
}

class _ChatInfoViewState extends State<ChatInfoView> {
  final providerRow = Provider.of<ChatRowProvider>(Get.context!, listen: false);
  final providerRowClear = Provider.of<ChatRowProvider>(Get.context!, listen: true);

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await Provider.of<ChatInfoProvider>(Get.context!, listen: false).getChatInfo(widget.id);
  }

  @override
  void dispose() {
    Provider.of<ChatInfoProvider>(Get.context!, listen: false).resetParams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 30;

    Color color;

    if (widget.service == 'allergo' || widget.service == 'allegro') {
      color = const Color(0xFFe67e22);
    } else if (widget.service == 'olx') {
      color = const Color(0xFF16a085);
    } else {
      color = primaryColor;
    }

    return Consumer<ChatInfoProvider>(builder: (context, provider, _) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              scrolledUnderElevation: 0,
              toolbarHeight: 46,
              elevation: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(Get.context!).pop();
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_ios, size: 18),
                          const Text(
                            'back',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                          ).tr(),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(context: context, backgroundColor: Colors.white, isScrollControlled: true, builder: (context) {
                          return ChatTranscriptionBottomSheetView(id: widget.id);
                        });
                      },
                      child: SvgPicture.asset('assets/images/envelope.svg', semanticsLabel: 'Share', width: 20, height: 20)
                    )
                  ],
                ),
              )
          ),
          body: SafeArea(
              child: provider.isLoader ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2c3e50)),
                        ),
                        const Spacer(),
                        widget.service == 'allergo' || widget.service == 'olx' ? Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Row(
                              children: [
                                if (widget.service == 'allergo' || widget.service == 'olx') SvgPicture.asset('assets/images/${widget.service}.svg', semanticsLabel: widget.service, width: 18, height: 15),
                                Expanded(
                                  child: Text('  ${widget.serviceLogin}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12), overflow: TextOverflow.ellipsis)
                                )
                              ],
                            ),
                          )
                        ) : Text(widget.service, style: const TextStyle(color: Color(0xFF2c3e50), fontWeight: FontWeight.w600, fontSize: 12), overflow: TextOverflow.ellipsis)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => provider.setPage(0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  decoration: BoxDecoration(
                                    color: provider.page == 0 ? primaryColor : Colors.white,
                                    border: Border.all(color: provider.page == 0 ? Colors.transparent : primaryColor, width: 2),
                                  ),
                                  width: width/2,
                                  child: Text(
                                    'text_files',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: provider.page == 0 ? Colors.white : primaryColor),
                                  ).tr(),
                                ),
                              ),
                              InkWell(
                                onTap: () => provider.setPage(1),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  decoration: BoxDecoration(
                                    color: provider.page == 1 ?  primaryColor : Colors.white,
                                    border: Border.all(color: provider.page == 1 ? Colors.transparent : primaryColor, width: 2),
                                  ),
                                  width: width/2,
                                  child: Text(
                                    'text_shared_info',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: provider.page == 1 ? Colors.white : primaryColor),
                                  ).tr(),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: PageView(
                            onPageChanged: (val) {
                              provider.setPage(val);
                            },
                            controller: provider.controller,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: const Text(
                                      'text_files',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2c3e50)),
                                    ).tr(),
                                  ),
                                  if (provider.chatInfo.data!.files != null && provider.chatInfo.data!.files!.isNotEmpty) Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10),
                                              Expanded(
                                                child: ListView.separated(
                                                    separatorBuilder: (BuildContext context, int index) {
                                                      return const Divider(thickness: .1);
                                                    },
                                                    itemCount: provider.chatInfo.data!.files!.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      final Files chat = provider.chatInfo.data!.files![index];

                                                      return GestureDetector(
                                                        onTap: () async {
                                                          if (!providerRow.getDownload(chat.id!)) {
                                                            if (await providerRow.requestPermission()) {
                                                              providerRow.setDownload(chat.id!);

                                                              await providerRow.downloadFile(chat.url!, chat.filename!, chat.id!);
                                                            }
                                                          }
                                                        },
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                providerRowClear.getDownload(chat.id!) || providerRow.getDownloaded(chat.id!) ? const Icon(Icons.download, size: 20, color: Color(0xFF2c3e50)) :
                                                                Icon(providerRowClear.getDownload(chat.id!) ? Icons.download_for_offline_sharp : Icons.download_outlined, size: 20, color: const Color(0xFF2c3e50)),
                                                                if (providerRowClear.getDownload(chat.id!) && !providerRow.getDownloaded(chat.id!)) const SizedBox(
                                                                    width: 20,
                                                                    height: 20,
                                                                    child: CircularProgressIndicator(color: Color(0xFF2c3e50), strokeWidth: 1)
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(width: 2),
                                                            Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 1, left: 2),
                                                                  child: Text(
                                                                    chat.filename!,
                                                                    textAlign: TextAlign.left,
                                                                    style: const TextStyle(fontSize: 12, color: Color(0xFF2c3e50)),
                                                                  ),
                                                                )
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              )
                                            ]
                                        ),
                                      )
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text(
                                      'text_shared_info',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2c3e50)),
                                    ).tr(),
                                    const SizedBox(height: 10),
                                    InkWell(
                                      onTap: () async {
                                        if (provider.chatInfo.user!.sharedAccess!.isEmpty) {
                                          snackBar(title: tr('error'), text: tr('text_empty_team'));
                                        } else {
                                          showModalBottomSheet(context: context, backgroundColor: Colors.white, builder: (context) {
                                            return ChatAddProvideView(id: widget.id, access: provider.chatInfo.user!.sharedAccess!);
                                          });
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset('assets/images/user_add.svg', semanticsLabel: 'Add user', width: 18, height: 15),
                                          const SizedBox(width: 6),
                                          const Text(
                                            'text_add_shared',
                                            style: TextStyle(fontSize: 12),
                                          ).tr(),
                                        ],
                                      )
                                    ),
                                    if (provider.chatInfo.data != null && provider.chatInfo.data!.access != null && provider.chatInfo.data!.access!.isNotEmpty) const SizedBox(height: 10),
                                    if (provider.chatInfo.data != null && provider.chatInfo.data!.access != null && provider.chatInfo.data!.access!.isNotEmpty) const Divider(thickness: .1, height: .1),
                                    Expanded(
                                      child: ListView.separated(
                                          separatorBuilder: (BuildContext context, int index) {
                                            return const Divider(thickness: .1, height: .1);
                                          },
                                          itemCount: provider.chatInfo.data!.access!.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            final String access = provider.chatInfo.data!.access![index];

                                            return Slidable(
                                              key: const ValueKey(1),
                                              endActionPane: ActionPane(
                                                dragDismissible: false,
                                                extentRatio: 0.22,
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                      onPressed: (BuildContext context) {
                                                        provider.removeProvide(widget.id, access);
                                                      },
                                                      spacing: 0,
                                                      backgroundColor: removeColor,
                                                      foregroundColor: Colors.white,
                                                      icon: Icons.delete
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 36,
                                                width: double.infinity,
                                                child: Text(
                                                  access,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(fontSize: 12, color: Color(0xFF2c3e50)),
                                                )
                                              )
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ) : const Center(
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(color: primaryColor)
                  )
              ),
          )
      );
    });
  }
}