import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../other/constant.dart';
import '../provider/reset_provider.dart';

class ResetView extends StatefulWidget {
  const ResetView({super.key});

  @override
  State<ResetView> createState() => _ResetViewState();
}

class _ResetViewState extends State<ResetView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 30;

    return Consumer<ResetProvider>(
        builder: (context, provider, _) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        const Text('text_reset_pas', style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600
                        )).tr(),
                        const SizedBox(height: 30),
                        const Text('Email'),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: width,
                          child: TextFormField(
                            controller: provider.controller,
                            focusNode: provider.focus,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            provider.reset();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            minimumSize: Size(width, 46),
                            elevation: 0,
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(width: 1, color: primaryColor)
                            ),
                          ),
                          child: provider.submitButton ? const CupertinoActivityIndicator(color: Colors.white, radius: 10) : const Text(
                            'text_reset',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ).tr(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          );
        }
    );
  }
}