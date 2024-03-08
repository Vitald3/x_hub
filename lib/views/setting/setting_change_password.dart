import 'package:easy_localization/easy_localization.dart';
import 'package:get/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import '../../provider/setting_change_password.dart';

class SettingChangePasswordView extends StatefulWidget {
  const SettingChangePasswordView({super.key});

  @override
  State<SettingChangePasswordView> createState() => _SettingChangePasswordViewState();
}

class _SettingChangePasswordViewState extends State<SettingChangePasswordView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 30;

    return Consumer<SettingChangePasswordProvider>(
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
                          onTap: () => Get.back(),
                          child: Row(
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
                          'text_change_pas',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                        ).tr(),
                        Container(
                            alignment: Alignment.centerRight,
                            width: 70,
                            child: InkWell(
                              onTap: () {
                                provider.change();
                              },
                              child: const Icon(Icons.check),
                            )
                        )
                      ],
                    )
                ),
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        const Text('text_new_pas').tr(),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: width,
                          child: TextFormField(
                            controller: provider.controller,
                            focusNode: provider.focus,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            autocorrect: false,
                            obscureText: provider.passwordHide,
                            enableSuggestions: false,
                            validator: (val) {
                              if (val == "") {
                                return tr('field_required');
                              }

                              return null;
                            },
                            onChanged: (val) {
                              if (provider.controller2.text != '' && provider.controller2.text != val) {
                                provider.state.currentState!.validate();
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  provider.setPasswordHide();
                                },
                              ),
                              hintText: tr('text_new_pas'),
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
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('text_confirm_new_pas').tr(),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: width,
                          child: TextFormField(
                            controller: provider.controller2,
                            focusNode: provider.focus2,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            autocorrect: false,
                            key: provider.state,
                            obscureText: provider.passwordHide2,
                            enableSuggestions: false,
                            validator: (val) {
                              if (val == "") {
                                return tr('field_required');
                              } else if (val != '' && val != provider.controller.text) {
                                return tr('text_confirm_error');
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  provider.setPasswordHide2();
                                },
                              ),
                              hintText: tr('text_confirm_new_pas'),
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
                      ],
                    )
                  )
              )
          );
        }
    );
  }
}