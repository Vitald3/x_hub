import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../other/constant.dart';
import '../provider/register_provider.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 30;

    return Consumer<RegisterProvider>(
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
                        const Text('welcome', style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600
                        )).tr(),
                        const Text('register_text').tr(),
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
                        const SizedBox(height: 10),
                        const Text('password').tr(),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: width,
                          child: TextFormField(
                            controller: provider.controller2,
                            obscureText: provider.passwordHide,
                            enableSuggestions: false,
                            focusNode: provider.focus2,
                            autocorrect: false,
                            validator: (val) {
                              if (val == "") {
                                return tr('field_required');
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: tr('password'),
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  provider.setPasswordHide();
                                },
                              ),
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
                        const Text('confirm').tr(),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: width,
                          child: TextFormField(
                            controller: provider.controller3,
                            obscureText: provider.passwordHide,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            enableSuggestions: false,
                            focusNode: provider.focus3,
                            autocorrect: false,
                            validator: (val) {
                              if (val == "") {
                                return tr('field_required');
                              } else if (provider.controller2.text != val) {
                                return tr('confirm_error');
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: tr('confirm'),
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  provider.setPasswordHide();
                                },
                              ),
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
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () async {
                            provider.register();
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
                            'register',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ).tr(),
                        ),
                        const SizedBox(height: 15),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black12),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              color: Colors.white,
                              child: const Text('or').tr(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Center(
                            child: Text.rich(
                              TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: tr('text_login'),
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: '',
                                        color: secondColor,
                                        decorationColor: Colors.transparent,
                                        decoration: TextDecoration.none,
                                        decorationStyle: TextDecorationStyle.solid
                                    ),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(builder: (_) => const LoginView()),
                                      );
                                    },
                                    text: " ${tr('log_in')}",
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: '',
                                      color: primaryColor,
                                      decorationColor: Colors.transparent,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            )
                        )
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