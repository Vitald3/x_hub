import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import 'package:x_hub/views/chat/chat_list_widget.dart';
import 'package:x_hub/views/chat/filters_view.dart';
import 'package:get/route_manager.dart';
import '../../models/chat_list_response_model.dart';
import '../../provider/chat_list_provider.dart';
import '../bottom_navigation_view.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    final provider = Provider.of<ChatListProvider>(Get.context!, listen: false);
    provider.resetParams();
    provider.getChatList(canceled: true);
    scrollController.addListener(scrollListener);
    provider.getFilters();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatListProvider>(Get.context!, listen: false).resetParams();
    });
  }

  void scrollListener() {
    final provider = Provider.of<ChatListProvider>(Get.context!, listen: false);

    if (provider.total > chatListLimit && !provider.searchBool && provider.chatListLength < provider.total && scrollController.position.pixels - 150 == scrollController.position.maxScrollExtent - 150 && !provider.loadMore) {
      provider.loadChat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - 200;

    return Consumer<ChatListProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                top: true,
                child: ColoredBox(
                    color: Colors.white,
                    child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            elevation: 0.5,
                            backgroundColor: Colors.white,
                            titleSpacing: 0,
                            scrolledUnderElevation: 0,
                            expandedHeight: 130,
                            floating: true,
                            flexibleSpace: FlexibleSpaceBar(
                                collapseMode: CollapseMode.pin,
                                background: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'chat_list_title',
                                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                                              ).tr(),
                                              if ((provider.filters.accounts != null && provider.filters.accounts!.isNotEmpty) || (provider.filters.sharedWith != null &&  provider.filters.sharedWith!.isNotEmpty)) InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet(context: context, backgroundColor: Colors.white, isScrollControlled: true, builder: (context) {
                                                      return FiltersView(filters: provider.filters);
                                                    });
                                                  },
                                                  child: Icon(Icons.filter_alt_outlined, color: provider.filterSelected ? primaryColor : null)
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            height: 38,
                                            child: TextFormField(
                                                cursorColor: primaryColor,
                                                controller: provider.controller,
                                                focusNode: provider.focus,
                                                onChanged: (val) {
                                                  provider.getChatList(reset: true);
                                                },
                                                decoration: InputDecoration(
                                                  hintText: tr('text_search'),
                                                  fillColor: const Color(0xFFecf0f1),
                                                  filled: true,
                                                  suffixIcon: provider.controller.text != '' ? IconButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Color(0xFF728A9D),
                                                    ),
                                                    onPressed: () {
                                                      provider.focus.unfocus();
                                                      provider.controller.clear();
                                                      provider.getChatList(reset: true);
                                                    },
                                                  ) : null,
                                                  prefixIcon: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: const Icon(
                                                      Icons.search,
                                                      color: Color(0xFF728A9D),
                                                    ),
                                                    onPressed: () {
                                                      provider.focus.unfocus();
                                                    },
                                                  ),
                                                  hintStyle: const TextStyle(
                                                      color: Color(0xFF728A9D),
                                                      fontSize: 14
                                                  ),
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                                                  focusedBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.transparent,
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                  ),
                                                  enabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.transparent,
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                  ),
                                                ),
                                                keyboardType: TextInputType.text
                                            ),
                                          ),
                                          const SizedBox(height: 10)
                                        ],
                                      ),
                                    )
                                  ],
                                )
                            ),
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(0.0),
                              child: Transform.translate(
                                offset: const Offset(0, 7),
                                child: const Divider(thickness: .3)
                              ),
                            ),
                          ),
                          SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            return provider.isLoader ? Padding(
                              padding: const EdgeInsets.all(15),
                              child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: provider.chatList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final DataChatList chat = provider.chatList[index];
                                    return chatListWidget(provider, chat);
                                  }, separatorBuilder: (BuildContext context, int index) {
                                    return const Divider(thickness: .1);
                                  }),
                            ) : Container(
                                alignment: Alignment.center,
                                height: height,
                                child: const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(color: primaryColor)
                                )
                            );
                          }, childCount: 1))
                        ]
                    )
                )
            ),
            bottomNavigationBar: const BottomNavigationView()
          );
        }
    );
  }
}