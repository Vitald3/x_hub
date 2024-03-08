import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import '../../models/chat_response_model.dart';
import '../../provider/chat_provider.dart';
import '../../provider/chat_row_provider.dart';
import '../../provider/setting_connected_account_provider.dart';

class ReceiverRowView extends StatefulWidget {
  const ReceiverRowView({super.key, required this.chat, required this.provider});

  final DataChat chat;
  final ChatProvider provider;

  @override
  State<ReceiverRowView> createState() => _ReceiverRowViewState();
}

class _ReceiverRowViewState extends State<ReceiverRowView> {
  bool download = false;
  bool downloaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatRowProvider>(builder: (context, chatRowProvider, _) {
      return Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 72,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person, size: 20, color: Color(0xFF2c3e50)),
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Text(
                          widget.chat.sender!,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2c3e50)
                          ),
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (!download && widget.chat.attachments != null && widget.chat.attachments!.isNotEmpty) {
                            if (await chatRowProvider.requestPermission()) {

                              setState(() {
                                download = true;
                              });

                              await chatRowProvider.downloadFile(widget.chat.attachments![0].url!, widget.chat.attachments![0].filename!, widget.chat.id!);

                              downloaded = true;
                              download = false;
                              setState(() {});
                            }
                          }
                        },
                        child: Container(
                            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                            decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(0xFFecf0f1),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.chat.message != '') SelectionArea(
                                  child: HtmlWidget(
                                    onTapUrl: (link) async {
                                      return Provider.of<SettingConnectedAccountProvider>(context, listen: false).openWebBool(link);
                                    },
                                    widget.chat.message!,
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF2c3e50)
                                    ),
                                  ),
                                ),
                                if (widget.chat.attachments != null && widget.chat.message != '') const SizedBox(height: 4),
                                if (widget.chat.attachments != null) Column(
                                  children: List.generate(widget.chat.attachments!.length, (index) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            downloaded || chatRowProvider.getDownloaded(widget.chat.id!) ? const Icon(Icons.download, size: 20, color: Color(0xFF2c3e50)) :
                                            Icon(download ? Icons.download_for_offline_sharp : Icons.download_outlined, size: 20, color: const Color(0xFF2c3e50)),
                                            if (download) const SizedBox(
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
                                                widget.chat.attachments![index].filename!,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(fontSize: 12, color: Color(0xFF2c3e50)),
                                              ),
                                            )
                                        )
                                      ],
                                    );
                                  }),
                                )
                              ],
                            )
                        ),
                      )
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(widget.provider.readTimestamp(widget.chat.createdAt!), style: const TextStyle(color: Color(0xFF2c3e50), fontSize: 9))
                  ),
                ],
              ),
              //
            ),
            Flexible(
              flex: 15,
              fit: FlexFit.tight,
              child: Container(
                width: 50,
              ),
            ),
          ],
        ),
      );
    });
  }
}