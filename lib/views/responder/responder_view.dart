import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:get/route_manager.dart';
import 'package:x_hub/views/responder/responder_edit_view.dart';
import '../../models/auto_responder_response_model.dart';
import '../../other/constant.dart';
import '../../provider/responder_provider.dart';
import '../bottom_navigation_view.dart';

class ResponderView extends StatefulWidget {
  const ResponderView({super.key});

  @override
  State<ResponderView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ResponderView> {

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    final provider = Provider.of<ResponderProvider>(Get.context!, listen: false);
    provider.getResponders();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResponderProvider>(Get.context!, listen: false).resetParams();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - 60;

    return Consumer<ResponderProvider>(
        builder: (context, provider, _) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.white,
                titleSpacing: 0,
                scrolledUnderElevation: 0,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'text_responder',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                      ).tr(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            Get.context!,
                            CupertinoPageRoute(builder: (_) => const ResponderEditView()),
                          );
                        },
                        child: const Icon(Icons.add),
                      )
                    ],
                  ),
                ),
              ),
              body: SafeArea(
                  child: Container(
                      alignment: provider.responders.isNotEmpty ? Alignment.topLeft : Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: provider.isLoader ? provider.responders.isNotEmpty ? ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(thickness: .1);
                          },
                          itemCount: provider.responders.length,
                          itemBuilder: (BuildContext context, int index) {
                            final RespondersModel item = provider.responders[index];

                            return Slidable(
                                key: const ValueKey(1),
                                endActionPane: ActionPane(
                                  dragDismissible: false,
                                  extentRatio: 0.22,
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                        onPressed: (BuildContext context) {
                                          provider.removeResponder(item.id!);
                                        },
                                        spacing: 0,
                                        backgroundColor: removeColor,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      Get.context!,
                                      CupertinoPageRoute(builder: (_) => ResponderEditView(item: item)),
                                    ).then((value) => provider.getResponders());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name!,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                                          ),
                                          Text(
                                            '${tr('text_connected_account')}: ${item.connectors!.length}',
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2c3e50)),
                                          ),
                                          const SizedBox(height: 6),
                                          Wrap(
                                            spacing: 12,
                                            children: [
                                              Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: (item.rules!.days!.mo ?? 0) == 1 ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                                    color: (item.rules!.days!.mo ?? 0) == 1 ? primaryColor : Colors.white
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'mo',
                                                  style: TextStyle(fontSize: 10, height: 1, color: (item.rules!.days!.mo ?? 0) == 1 ? Colors.white : const Color(0xFF2c3e50)),
                                                ).tr(),
                                              ),
                                              Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: (item.rules!.days!.tu ?? 0) == 1 ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                                    color: (item.rules!.days!.tu ?? 0) == 1 ? primaryColor : Colors.white
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'tu',
                                                  style: TextStyle(fontSize: 10, height: 1, color: (item.rules!.days!.tu ?? 0) == 1 ? Colors.white : const Color(0xFF2c3e50)),
                                                ).tr(),
                                              ),
                                              Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: (item.rules!.days!.we ?? 0) == 1 ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                                    color: (item.rules!.days!.we ?? 0) == 1 ? primaryColor : Colors.white
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'we',
                                                  style: TextStyle(fontSize: 10, height: 1, color: (item.rules!.days!.we ?? 0) == 1 ? Colors.white : const Color(0xFF2c3e50)),
                                                ).tr(),
                                              ),
                                              Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: (item.rules!.days!.th ?? 0) == 1 ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                                    color: (item.rules!.days!.th ?? 0) == 1 ? primaryColor : Colors.white
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'th',
                                                  style: TextStyle(fontSize: 10, height: 1, color: (item.rules!.days!.th ?? 0) == 1 ? Colors.white : const Color(0xFF2c3e50)),
                                                ).tr(),
                                              ),
                                              Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: (item.rules!.days!.fr ?? 0) == 1 ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                                    color: (item.rules!.days!.fr ?? 0) == 1 ? primaryColor : Colors.white
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'fr',
                                                  style: TextStyle(fontSize: 10, height: 1, color: (item.rules!.days!.fr ?? 0) == 1 ? Colors.white : const Color(0xFF2c3e50)),
                                                ).tr(),
                                              ),
                                              Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: (item.rules!.days!.sa ?? 0) == 1 ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                                    color: (item.rules!.days!.sa ?? 0) == 1 ? primaryColor : Colors.white
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'sa',
                                                  style: TextStyle(fontSize: 10, height: 1, color: (item.rules!.days!.sa ?? 0) == 1 ? Colors.white : const Color(0xFF2c3e50)),
                                                ).tr(),
                                              ),
                                              Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: (item.rules!.days!.su ?? 0) == 1 ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                                    color: (item.rules!.days!.su ?? 0) == 1 ? primaryColor : Colors.white
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'su',
                                                  style: TextStyle(fontSize: 10, height: 1, color: (item.rules!.days!.su ?? 0) == 1 ? Colors.white : const Color(0xFF2c3e50)),
                                                ).tr(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 6),
                                        child: Text(
                                          (item.status ?? 0) == 0 ? 'text_pause' : 'text_active',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                                        ).tr(),
                                      )
                                    ],
                                  )
                                )
                            );
                          }) : const Text(
                          'text_responder_empty',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)
                      ).tr() : Container(
                          alignment: Alignment.center,
                          height: height,
                          child: const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(color: primaryColor)
                          )
                      )
                  )
              ),
              bottomNavigationBar: const BottomNavigationView()
          );
        }
    );
  }
}