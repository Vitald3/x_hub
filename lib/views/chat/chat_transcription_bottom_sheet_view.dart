import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import '../../provider/chat_transcription_provider.dart';

class ChatTranscriptionBottomSheetView extends StatelessWidget {
  const ChatTranscriptionBottomSheetView({super.key, required this.id});

  final int id;

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
                        'text_send_transcription',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                      ).tr(),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: width,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: provider.controller,
                          focusNode: provider.focus,
                          autocorrect: false,
                          validator: (val) {
                            if (val == "") {
                              return tr('field_required');
                            } else if (val != "" && !EmailValidator.validate(val!)) {
                              return tr('email_validate');
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Email",
                            fillColor: Colors.white,
                            filled: true,
                            hintStyle: const TextStyle(
                                color: Color(0xFF728A9D),
                                fontSize: 14
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Color(0xFF85A0AA),
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Color(0xFF85A0AA),
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(height: 15),
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
                                FocusScope.of(context).unfocus();

                                if (provider.controller.text != "" && EmailValidator.validate(provider.controller.text)) {
                                  provider.addTranscription(id).then((value) => Navigator.of(context).pop());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  elevation: 0,
                                  minimumSize: Size((width/2)-23, 38)
                              ),
                              child: !provider.submit ? const Text(
                                'text_send',
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