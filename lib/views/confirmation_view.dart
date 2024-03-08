import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:provider/provider.dart';
import '../other/constant.dart';
import '../provider/confirmation_provider.dart';
import 'package:get/route_manager.dart';

class ConfirmationView extends StatefulWidget {
  const ConfirmationView({super.key, required this.email, this.token, this.reset});

  final String email;
  final String? token;
  final bool? reset;

  @override
  State<ConfirmationView> createState() => _ConfirmationViewState();
}

class _ConfirmationViewState extends State<ConfirmationView> {
  @override
  void initState() {
    final provider = Provider.of<ConfirmationProvider>(Get.context!, listen: false);
    provider.setEmail(widget.email);
    provider.setStrToken(widget.token ?? '');
    provider.setReset(widget.reset ?? false);

    if (!(widget.reset ?? false)) {
      provider.getCode();
    } else {
      provider.startTimer();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - 110;

    return Consumer<ConfirmationProvider>(
        builder: (context, provider, _) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: height,
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'digit_code',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: secondColor,
                                fontSize: 21,
                                fontWeight: FontWeight.w300
                            ),
                          ).tr(),
                          const SizedBox(height: 40),
                          VerificationCode(
                            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                            keyboardType: TextInputType.number,
                            length: 6,
                            itemSize: 44,
                            underlineColor: primaryColor,
                            underlineUnfocusedColor: const Color(0xFFD2D2D2),
                            cursorColor: primaryColor,
                            fillColor: const Color(0xFFEFEFEF),
                            fullBorder: true,
                            margin: const EdgeInsets.all(3),
                            onCompleted: (String value) {
                              provider.setCode(value);
                            },
                            onEditing: (bool value) {
                              provider.setEditing(value);
                              if (!provider.editing) FocusScope.of(context).unfocus();
                            },
                          ),
                          const SizedBox(height: 10),
                          provider.count > 0 ? Text(
                            '${tr('text_after')} ${provider.strCount} s',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: secondColor,
                                fontSize: 19,
                                fontWeight: FontWeight.w300
                            ),
                          ) : InkWell(
                              onTap: () {
                                provider.reSend();
                              },
                              child: const Text(
                                'text_send_code',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w300
                                ),
                              ).tr()
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () async {
                              provider.confirm();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              minimumSize: const Size(160, 46),
                              elevation: 0,
                              alignment: Alignment.center,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(width: 1, color: primaryColor)
                              ),
                            ),
                            child: provider.submitButton ? const CupertinoActivityIndicator(color: Colors.white, radius: 10) : const Text(
                              'text_confirm',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14
                              ),
                            ).tr(),
                          ),
                        ],
                      ),
                    )
                  ),
                ),
              )
          );
        }
    );
  }
}