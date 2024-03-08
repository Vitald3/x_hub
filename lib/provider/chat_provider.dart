import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/models/message_data_model.dart';
import 'package:get/route_manager.dart';
import '../models/chat_list_response_model.dart';
import '../models/chat_response_model.dart';
import '../models/shortcuts_response_model.dart';
import '../other/constant.dart';
import '../services/api.dart';
import 'chat_list_provider.dart';
import 'chat_shortcuts_provider.dart';

class ChatProvider extends ChangeNotifier {
  var chat = <DataChat>[];
  var conversation = DataChatList();
  final ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  double inputHeight = 40;
  bool submit = false;
  bool isLoader = false;
  int total = 0;
  int offsetChat = 0;
  int offsetChatBottom = 0;
  int chatId = 0;
  bool loadMore = false;
  bool loadAttachment = false;
  PlatformFile? files;
  double shortcutsVisible = 0;
  var shortcuts = <ShortcutsModel>[];
  bool boolBefore = false;
  int qtyAfter = 0;
  int qtyBefore = 0;
  bool bottomStop = false;
  bool timerStop = true;
  double newMessage = 0.0;
  double positions = 0;

  Future<void> sendMessage(int id) async {
    setSubmit(true);

    var message = MessageDataModel(
        message: textEditingController.text
    );

    chat.insert(0, DataChat(attachments: [], conversationId: chatId, id: -1, message: textEditingController.text, sender: '', status: 1, youSender: true, createdAt: DateTime.timestamp().millisecondsSinceEpoch));
    update();

    if (files != null) {
      message.attachment = Attachments(filename: files!.name, url: await loadAttachments());
    }
    
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    textEditingController.clear();
    var response = await Api.sendMessage(id, message);

    if (response.success ?? false) {
      scrollAnimation();
    }

    setSubmit(false);
  }

  void setSubmit(bool val) {
    submit = val;
    notifyListeners();
  }

  Future<void> getChat(int id, {int? before, int? offset = 0, bool timer = false}) async {
    if (before != null) {
      boolBefore = true;
    }

    Api.getChat(id, before: before).then((response) {
      chatId = id;

      if (response.chatResponse != null) {
        if (chat.isEmpty) {
          chat = response.chatResponse!.data ?? [];
          total = response.chatResponse!.total ?? 0;
        } else {
          var chatCopy = <DataChat>[];

          for (var i in chat) {
            if ((i.id ?? 0) > -1) {
              chatCopy.add(i);
            }
          }

          for (var element in response.chatResponse!.data!) {
            if (chatCopy.where((elementWhere) => elementWhere.id == element.id).isEmpty) {
              chatCopy.insert(0, element);
            }
          }

          if (scrollController.hasClients && scrollController.position.pixels > scrollController.position.minScrollExtent && chatCopy.length > chat.length) {
            newMessage = 1.0;
          }

          chat = chatCopy;
        }

        if (response.chatResponse!.qtyAfter != null && qtyAfter == 0) {
          qtyAfter = response.chatResponse!.qtyAfter!;
        }

        if (response.chatResponse!.qtyBefore != null && qtyBefore == 0) {
          qtyBefore = response.chatResponse!.qtyBefore!;

          if (before != null) {
            offsetChat = total - qtyBefore;
          }
        }
      }

      if (response.chatResponse?.conversation != null) {
        conversation = response.chatResponse!.conversation!;
      }

      isLoader = true;

      if (before == null && !timer) {
        scrollAnimation();
      }

      if (total == offsetChat && qtyAfter == 0) {
        scrollController.removeListener(scroll);
      }

      notifyListeners();

      if (Provider.of<ChatListProvider>(Get.context!, listen: false).textSearch != '' && total > 0 && total > chat.length) {
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
          timer.cancel();
          positions = scrollController.position.maxScrollExtent + (MediaQuery.of(Get.context!).size.height - 130);
          loadBottomMessageMore(chatId);
        });
      }
    });
  }

  Future<void> loadMessageMore(int id) async {
    loadMore = true;
    offsetChat += chatMessageLimit;

    Api.getChat(id, offset: offsetChat).then((response) {
      if (response.chatResponse != null) {
        for (var i in response.chatResponse!.data ?? []) {
          chat.add(i);
        }
      }

      if (total == offsetChat) {
        scrollController.removeListener(scroll);
      }

      loadMore = false;

      notifyListeners();
    });
  }

  Future<void> loadBottomMessageMore(int id) async {
    loadMore = true;

    if (offsetChatBottom == 0) {
      offsetChatBottom = (qtyAfter + 1) - chatMessageLimit;
    } else {
      offsetChatBottom -= chatMessageLimit;
    }

    if (offsetChatBottom <= 0) {
      bottomStop = true;
      offsetChatBottom = 0;
    }

    if (positions == 0) {
      positions = scrollController.position.maxScrollExtent;
    } else {
      positions = positions - scrollController.position.pixels;
    }

    Api.getChat(id, offset: offsetChatBottom).then((response) {
      if (response.chatResponse != null) {
        for (var (index, i) in response.chatResponse!.data!.reversed.indexed) {
          final where = chat.lastIndexWhere((elementIndex) => elementIndex.id == i.id);

          if (where > -1) {
            chat.removeAt(where);
            chat.insert(index, i);
          } else {
            chat.insert(0, i);
          }
        }
      }

      loadMore = false;
      scrollController.jumpTo(positions);
      notifyListeners();
    });
  }

  void update() {
    notifyListeners();
  }

  void setTimerStop(bool val, {bool update = true}) {
    timerStop = val;

    if (update) {
      notifyListeners();
    }
  }

  void setNewMessage(double val) {
    newMessage = val;
    notifyListeners();
  }

  void resetParams() {
    chat = [];
    submit = false;
    inputHeight = 40;
    loadMore = false;
    offsetChat = 0;
    files = null;
    loadAttachment = false;
    shortcutsVisible = 0;
    shortcuts = [];
    qtyAfter = 0;
    qtyBefore = 0;
    positions = 0.0;
    boolBefore = false;
    bottomStop = false;
    timerStop = true;
    offsetChatBottom = 0;
    newMessage = 0.0;
    notifyListeners();
  }

  void scroll() {
    if (total > 0 && total > chat.length) {
      if (total > offsetChat && !loadMore && scrollController.position.pixels + 150 == scrollController.position.maxScrollExtent + 150) {
        loadMessageMore(chatId);
      } else if (!bottomStop && offsetChatBottom >= 0 && !loadMore && scrollController.position.pixels - (offsetChatBottom == 0 ? 0 : 150) == scrollController.position.minScrollExtent - (offsetChatBottom == 0 ? 0 : 150)) {
        loadBottomMessageMore(chatId);
      }
    }

    if (newMessage > 0 && scrollController.position.pixels == scrollController.position.minScrollExtent) {
      newMessage = 0.0;
      notifyListeners();
    }
  }

  void scrollListener(int id) {
    scrollController.addListener(scroll);
  }

  void setLoadAttachment(bool val) {
    loadAttachment = val;
    files = null;
    notifyListeners();
  }

  Future<void> setAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );

    if (result != null) {
      loadAttachment = false;
      files = result.files.first;
      notifyListeners();
    }
  }

  Future<String> loadAttachments() async {
    loadAttachment = true;
    var url = '';

    final response = await Api.loadFiles(chatId, files!);

    if (response.attachmentResponse != null) {
      url = response.attachmentResponse!.url!;
    }

    loadAttachment = false;
    files = null;

    return url;
  }

  void scrollAnimation() async {
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void setShortcutsVisible(double val, String text) {
    shortcutsVisible = val;
    shortcuts = [];

    if (text != '') {
      final items = Provider.of<ChatShortcutsProvider>(Get.context!, listen: false).shortcuts;

      for (var i in items) {
        if (i.shortcut!.contains(text.replaceFirst('/', ''))) {
          shortcuts.add(i);
        }
      }
    }

    notifyListeners();
  }

  void setShortcutsHide() {
    shortcutsVisible = 0;
    shortcuts = [];
    notifyListeners();
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var format2 = DateFormat('dd.MM');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      time = format2.format(date);
    } else {
      time = format2.format(date);
    }

    return time.replaceAll(' AM', '').replaceAll(' PM', '');
  }
}