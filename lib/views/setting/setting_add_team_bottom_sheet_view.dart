import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import 'package:x_hub/provider/setting_my_team_provider.dart';

class SettingAddTeamBottomSheetView extends StatelessWidget {
  const SettingAddTeamBottomSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer<SettingMyTeamProvider>(builder: (context, provider, _) {
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
                        'text_add_new',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                      ).tr(),
                      const SizedBox(height: 20),
                      const Text(
                        'Email',
                        style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                      ).tr(),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: width,
                        child: TextFormField(
                          controller: provider.controller,
                          focusNode: provider.focus,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          textInputAction: TextInputAction.done
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'text_access',
                        style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                      ).tr(),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: provider.accessSelected,
                        icon: const Icon(Icons.arrow_drop_down),
                        hint: const Text(
                          'text_access',
                          style: TextStyle(fontSize: 13, color: Color(0xFF2c3e50)),
                        ).tr(),
                        style: const TextStyle(color: Color(0xFF2c3e50)),
                        onChanged: (String? value) {
                          provider.setAccessSelected(value!);
                        },
                        items: ['Limit access', 'Full access'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
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
                                if (EmailValidator.validate(provider.controller.text)) {
                                  FocusScope.of(context).unfocus();
                                  provider.addMyTeam().then((value) => Navigator.of(context).pop());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  elevation: 0,
                                  minimumSize: Size((width/2)-23, 38)
                              ),
                              child: !provider.submit ? const Text(
                                'text_add',
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