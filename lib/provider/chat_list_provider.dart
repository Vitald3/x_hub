import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/models/chat_list_response_model.dart';
import 'package:x_hub/models/user_response_model.dart';
import 'package:get/route_manager.dart';
import '../models/filters_response_model.dart';
import '../other/constant.dart';
import '../services/api.dart';
import 'chat_provider.dart';
import 'filters_provider.dart';

class ChatListProvider extends ChangeNotifier {
  var chatList = <DataChatList>[];
  var filters = Filters();
  UserResponse? user;
  FocusNode focus = FocusNode();
  bool isLoader = false;
  bool loadMore = false;
  int offset = 0;
  int total = 0;
  int chatListLength = 0;
  bool filterSelected = false;
  Timer? timer;
  bool cancel = false;
  bool searchBool = false;
  String textSearch = '';
  final controller = TextEditingController();

  void resetParams() {
    offset = 0;
    total = 0;
    chatList = [];
    chatListLength = 0;
    loadMore = false;
    timer?.cancel();
    timer = null;
    cancel = true;
    textSearch = '';
    searchBool = false;
    Provider.of<FiltersProvider>(Get.context!, listen: false).resetParams();
  }

  void cancelTimer() {
    timer?.cancel();
    timer = null;
    cancel = true;
    notifyListeners();
  }

  Future<void> getChatList({bool reset = false, bool canceled = false}) async {
    if (canceled) {
      cancel = false;
      Provider.of<ChatProvider>(Get.context!, listen: false).setTimerStop(true, update: false);
    }
print(1);
    searchBool = controller.text != '';
    textSearch = controller.text;

    final filtersProvider = Provider.of<FiltersProvider>(Get.context!, listen: false);

    if (filtersProvider.selected != null || filtersProvider.selected2 != null) {
      filterSelected = true;
    } else {
      filterSelected = false;
    }

    if (reset) {
      chatListLength = chatList.length;
      loadMore = false;
    }

    Api.getChatList(account: filtersProvider.selected ?? '', sharedWith: filtersProvider.selected2 ?? '', search: controller.text).then((response) {
      if (response.chatListResponse != null) {
        total = response.chatListResponse!.total ?? 0;

        if (chatList.isEmpty || reset) {
          chatList = response.chatListResponse!.data!;

          if (!reset && user == null) {
            user = response.chatListResponse!.user!;
          }
        } else {
          for (var (index, element) in response.chatListResponse!.data!.indexed) {
            final where = chatList.lastIndexWhere((elementIndex) => elementIndex.id == element.id);

            if (where > -1) {
              chatList.removeAt(where);
              chatList.insert(index, element);
            }
          }
        }

        chatListLength = chatList.length;
      }

      if (controller.text != '') {
        timer?.cancel();
        timer = null;
      } else if (!cancel) {
        timer ??= Timer.periodic(const Duration(seconds: 5), (timer) {
          getChatList(reset: reset);
        });
      }

      isLoader = true;
      loadMore = false;
      notifyListeners();
    });
  }

  Future<void> getFilters() async {
    Api.getFilters().then((response) {
      if (response.filtersResponse != null) {
        filters = response.filtersResponse!.data!;
        notifyListeners();
      }
    });
  }

  void loadChat() async {
    offset += chatListLimit;
    loadMore = true;

    Api.getChatList(offset: offset).then((response) {
      if (response.chatListResponse != null) {
        chatList.addAll(response.chatListResponse!.data!);
        chatListLength = chatList.length;
      }

      loadMore = false;
      notifyListeners();
    });
  }
}