import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import 'package:get/route_manager.dart';
import '../../models/shortcuts_response_model.dart';
import '../../provider/add_shortcut_provider.dart';

class AddShortcutsView extends StatelessWidget {
  const AddShortcutsView({super.key, this.edit});

  final ShortcutsModel? edit;

  bool validEnglish(String value) {
    RegExp regex = RegExp('[a-z A-Z 0-9]');
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: Provider.of<AddShortcutProvider>(Get.context!, listen: false).text ?? (edit?.shortcut ?? ''));
    final focus = FocusNode();
    final controller2 = TextEditingController(text: Provider.of<AddShortcutProvider>(Get.context!, listen: false).text2 ?? (edit?.text ?? ''));
    final focus2 = FocusNode();

    return Consumer<AddShortcutProvider>(builder: (context, provider, _) {
      final width = MediaQuery.of(context).size.width;

      return SafeArea(
        top: true,
        child: Wrap(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: MediaQuery.of(context).viewInsets.bottom + 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'text_add2',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                    ).tr(),
                    const SizedBox(height: 20),
                    const Text(
                      'text_shortcut',
                      style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                    ).tr(),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            '/',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          constraints: const BoxConstraints(
                            minHeight: 38,
                          ),
                          width: width-51,
                          child: TextFormField(
                              cursorColor: primaryColor,
                              controller: controller,
                              focusNode: focus,
                              decoration: const InputDecoration(
                                fillColor: Color(0xFFecf0f1),
                                filled: true,
                                hintStyle: TextStyle(
                                    color: Color(0xFF728A9D),
                                    fontSize: 14
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                              ),
                              validator: (val) {
                                provider.setText(val!);

                                if (val == "") {
                                  return tr('field_required');
                                } else if (val != '' && !validEnglish(val)) {
                                  return tr('field_shortcut');
                                }

                                return null;
                              },
                              onChanged: (val) {
                                if (val != '' && val[0] == '/') {
                                  controller.text = controller.text.replaceFirst('/', '');
                                }
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'text',
                      style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                    ).tr(),
                    const SizedBox(height: 8),
                    TextFormField(
                        cursorColor: primaryColor,
                        controller: controller2,
                        focusNode: focus2,
                        minLines: 4,
                        maxLines: 4,
                        onChanged: (val) {
                          provider.setText2(val);
                        },
                        decoration: const InputDecoration(
                          fillColor: Color(0xFFecf0f1),
                          filled: true,
                          hintStyle: TextStyle(
                              color: Color(0xFF728A9D),
                              fontSize: 14
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                        ),
                        validator: (val) {
                          if (val == '') {
                            return tr('field_required');
                          }

                          return null;
                        },
                        keyboardType: TextInputType.text
                    ),
                    const SizedBox(height: 12),
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
                            if (controller.text == '') {
                              focus.requestFocus();
                            }

                            if (controller.text != '' && controller2.text == '') {
                              focus2.requestFocus();
                            }

                            if (!provider.shortcutAdd && controller.text != '' && validEnglish(controller.text) && controller2.text != '') {
                              await provider.addShortcut(controller.text, controller2.text, edit);

                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              elevation: 0,
                              minimumSize: Size((width/2)-23, 38)
                          ),
                          child: provider.shortcutAdd ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white)
                          ) : Text(
                            edit == null ? 'text_add_modal' : 'text_edit_modal',
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                          ).tr(),
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