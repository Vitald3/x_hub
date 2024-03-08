import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import 'package:x_hub/views/responder/responder_account_view.dart';
import '../../models/auto_responder_response_model.dart';
import '../../models/setting_connected_account_response_model.dart';
import '../../other/extensions.dart';
import '../../provider/responder_edit_provider.dart';

class ResponderEditView extends StatefulWidget {
  const ResponderEditView({super.key, this.item});

  final RespondersModel? item;

  @override
  State<ResponderEditView> createState() => _ResponderEditViewState();
}

class _ResponderEditViewState extends State<ResponderEditView> {

  @override
  void initState() {
    Provider.of<ResponderEditProvider>(Get.context!, listen: false).resetParams();
    Provider.of<ResponderEditProvider>(Get.context!, listen: false).getConnected();
    if (widget.item != null) {
      Provider.of<ResponderEditProvider>(Get.context!, listen: false).setItem(widget.item!);
    }
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ResponderEditProvider>(Get.context!, listen: false).resetParams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 30;
    final double height = MediaQuery.of(context).size.height - 80;

    return Consumer<ResponderEditProvider>(
        builder: (context, provider, _) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.white,
                titleSpacing: 0,
                scrolledUnderElevation: 0,
                title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.arrow_back_ios, size: 18),
                              const Text(
                                'create_responder',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                              ).tr(),
                            ],
                          ),
                        ),
                      ],
                    )
                ),
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: provider.isLoader ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'text_responder_name',
                          style: TextStyle(fontSize: 14, color: secondColor),
                        ).tr(),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 44,
                          width: width,
                          child: TextFormField(
                            controller: provider.controller,
                            focusNode: provider.focus,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            autocorrect: false,
                            validator: (val) {
                              if (val == "") {
                                return tr('field_required');
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: tr('text_responder_name'),
                              fillColor: Colors.white,
                              filled: true,
                              hintStyle: const TextStyle(
                                  color: Color(0xFF728A9D),
                                  fontSize: 14
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'text_choose',
                          style: TextStyle(fontSize: 14, color: secondColor),
                        ).tr(),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 15,
                          children: [
                            InkWell(
                              onTap: () {
                                provider.setDays(1);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: provider.day.contains(1) ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                    color: provider.day.contains(1) ? primaryColor : Colors.white
                                ),
                                child: Text(
                                  'mo',
                                  style: TextStyle(fontSize: 12, height: 1, color: provider.day.contains(1) ? Colors.white : const Color(0xFF2c3e50)),
                                ).tr(),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                provider.setDays(2);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: provider.day.contains(2) ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                    color: provider.day.contains(2) ? primaryColor : Colors.white
                                ),
                                child: Text(
                                  'tu',
                                  style: TextStyle(fontSize: 12, height: 1, color: provider.day.contains(2) ? Colors.white : const Color(0xFF2c3e50)),
                                ).tr(),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                provider.setDays(3);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: provider.day.contains(3) ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                    color: provider.day.contains(3) ? primaryColor : Colors.white
                                ),
                                child: Text(
                                  'we',
                                  style: TextStyle(fontSize: 12, height: 1, color: provider.day.contains(3) ? Colors.white : const Color(0xFF2c3e50)),
                                ).tr(),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                provider.setDays(4);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: provider.day.contains(4) ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                    color: provider.day.contains(4) ? primaryColor : Colors.white
                                ),
                                child: Text(
                                  'th',
                                  style: TextStyle(fontSize: 12, height: 1, color: provider.day.contains(4) ? Colors.white : const Color(0xFF2c3e50)),
                                ).tr(),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                provider.setDays(5);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: provider.day.contains(5) ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                    color: provider.day.contains(5) ? primaryColor : Colors.white
                                ),
                                child: Text(
                                  'fr',
                                  style: TextStyle(fontSize: 12, height: 1, color: provider.day.contains(5) ? Colors.white : const Color(0xFF2c3e50)),
                                ).tr(),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                provider.setDays(6);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: provider.day.contains(6) ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                    color: provider.day.contains(6) ? primaryColor : Colors.white
                                ),
                                child: Text(
                                  'sa',
                                  style: TextStyle(fontSize: 12, height: 1, color: provider.day.contains(6) ? Colors.white : const Color(0xFF2c3e50)),
                                ).tr(),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                provider.setDays(7);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: provider.day.contains(7) ? primaryColor : const Color(0xFF2c3e50), width: 1),
                                    color: provider.day.contains(7) ? primaryColor : Colors.white
                                ),
                                child: Text(
                                  'su',
                                  style: TextStyle(fontSize: 12, height: 1, color: provider.day.contains(7) ? Colors.white : const Color(0xFF2c3e50)),
                                ).tr(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'text_from',
                              style: TextStyle(fontSize: 14, color: secondColor),
                            ).tr(),
                            SizedBox(
                              height: 44,
                              width: width/2,
                              child: TextFormField(
                                controller: provider.controller2,
                                readOnly: true,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: '__:__',
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintStyle: const TextStyle(
                                      color: Color(0xFF728A9D),
                                      fontSize: 14
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
                                keyboardType: TextInputType.datetime,
                                onTap: () {
                                  showModalBottomSheet(context: context, backgroundColor: Colors.white, builder: (context) {
                                    return Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        const SizedBox(height: 20),
                                        CupertinoTimerPicker(
                                            mode: CupertinoTimerPickerMode.hm,
                                            onTimerDurationChanged: (val) {
                                              provider.setFrom('${val.inHours}:${'${val.inMinutes%60}'.padLeft(2, '0')}');
                                            }
                                        ),
                                        const SizedBox(height: 20),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    provider.controller2.text = '';
                                                    provider.setFrom('');
                                                    provider.update();
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFF2c3e50),
                                                    minimumSize: Size(width/2-10, 46),
                                                    elevation: 0,
                                                    alignment: Alignment.center,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: const BorderSide(width: 1, color: Color(0xFF2c3e50))
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'text_reset',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14
                                                    ),
                                                  ).tr(),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    provider.controller2.text = provider.from;
                                                    final str = provider.from.split(':');

                                                    if (str.isNotEmpty && provider.controller3.text == '') {
                                                      provider.controller3.text = '${(int.tryParse(str[0]) ?? 0) + 1}:${str[1]}';
                                                      provider.setTo('${(int.tryParse(str[0]) ?? 0) + 1}:${str[1]}');
                                                    }

                                                    provider.setFrom('');
                                                    provider.update();
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: primaryColor,
                                                    minimumSize: Size(width/2-10, 46),
                                                    elevation: 0,
                                                    alignment: Alignment.center,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: const BorderSide(width: 1, color: primaryColor)
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'next',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14
                                                    ),
                                                  ).tr(),
                                                )
                                              ],
                                            )
                                        )
                                      ],
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'text_to',
                              style: TextStyle(fontSize: 14, color: secondColor),
                            ).tr(),
                            SizedBox(
                              height: 44,
                              width: width/2,
                              child: TextFormField(
                                controller: provider.controller3,
                                readOnly: true,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: '__:__',
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintStyle: const TextStyle(
                                      color: Color(0xFF728A9D),
                                      fontSize: 14
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
                                keyboardType: TextInputType.datetime,
                                onTap: () {
                                  showModalBottomSheet(context: context, backgroundColor: Colors.white, builder: (context) {
                                    return Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        const SizedBox(height: 20),
                                        CupertinoTimerPicker(
                                            mode: CupertinoTimerPickerMode.hm,
                                            onTimerDurationChanged: (val) {
                                              provider.setTo('${val.inHours}:${'${val.inMinutes%60}'.padLeft(2, '0')}');
                                            }
                                        ),
                                        const SizedBox(height: 20),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    provider.controller3.text = '';
                                                    provider.setTo('');
                                                    provider.update();
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFF2c3e50),
                                                    minimumSize: Size(width/2-10, 46),
                                                    elevation: 0,
                                                    alignment: Alignment.center,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: const BorderSide(width: 1, color: Color(0xFF2c3e50))
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'text_reset',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14
                                                    ),
                                                  ).tr(),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    provider.controller3.text = provider.to;
                                                    provider.setTo('');
                                                    provider.update();
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: primaryColor,
                                                    minimumSize: Size(width/2-10, 46),
                                                    elevation: 0,
                                                    alignment: Alignment.center,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: const BorderSide(width: 1, color: primaryColor)
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'next',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14
                                                    ),
                                                  ).tr(),
                                                )
                                              ],
                                            )
                                        )
                                      ],
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'text_responder_after',
                              style: TextStyle(fontSize: 14, color: secondColor),
                            ).tr(),
                            SizedBox(
                              height: 44,
                              width: width/2,
                              child: TextFormField(
                                controller: provider.controller4,
                                readOnly: true,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: '0 minutes',
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintStyle: const TextStyle(
                                      color: Color(0xFF728A9D),
                                      fontSize: 14
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
                                keyboardType: TextInputType.datetime,
                                onTap: () {
                                  showModalBottomSheet(context: context, backgroundColor: Colors.white, builder: (context) {
                                    final items = [0,5,10,15,20,25,30,35,40,45,50,55,60];

                                    return Wrap(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'text_select',
                                                  style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                                                ).tr(),
                                                const SizedBox(height: 10),
                                                DropdownButton<int>(
                                                    isExpanded: true,
                                                    value: Provider.of<ResponderEditProvider>(Get.context!, listen: true).after,
                                                    icon: const Icon(Icons.arrow_drop_down),
                                                    hint: const Text(
                                                      'text_select',
                                                      style: TextStyle(fontSize: 13, color: Color(0xFF2c3e50)),
                                                    ).tr(),
                                                    style: const TextStyle(color: Color(0xFF2c3e50)),
                                                    onChanged: (int? value) {
                                                      provider.setAfter(value!);
                                                    },
                                                    items: List.generate(items.length, (index) {
                                                      return DropdownMenuItem<int>(
                                                        value: items[index],
                                                        child: Text('${items[index]}'),
                                                      );
                                                    })
                                                ),
                                              ],
                                            )
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    provider.controller4.text = '';
                                                    provider.setAfter(0);
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0xFF2c3e50),
                                                    minimumSize: Size(width/2-10, 46),
                                                    elevation: 0,
                                                    alignment: Alignment.center,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: const BorderSide(width: 1, color: Color(0xFF2c3e50))
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'text_reset',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14
                                                    ),
                                                  ).tr(),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    provider.controller4.text = '${provider.after} minutes';
                                                    provider.setAfter(0);
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: primaryColor,
                                                    minimumSize: Size(width/2-10, 46),
                                                    elevation: 0,
                                                    alignment: Alignment.center,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: const BorderSide(width: 1, color: primaryColor)
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'next',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14
                                                    ),
                                                  ).tr(),
                                                )
                                              ],
                                            )
                                        )
                                      ],
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'text_for_accounts',
                          style: TextStyle(fontSize: 14, color: secondColor),
                        ).tr(),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.white, builder: (context) {
                              return ResponderAccountsView(connected: provider.connectedAccounts);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: const Color(0xFF85A0AA), width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            width: width,
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: provider.connectors.isNotEmpty && provider.connectedAccounts.isNotEmpty ? Wrap(
                                      runSpacing: 6,
                                      spacing: 15,
                                      children: List.generate(provider.connectors.length, (index) {
                                        final ConnectedAccount? item = provider.connectedAccounts.firstWhereOrNull((element) => element.id == provider.connectors[index]);

                                        return item != null ? Container(
                                            decoration: BoxDecoration(
                                              color: primaryColor.withOpacity(.4),
                                              borderRadius: BorderRadius.circular(4.0),
                                              border: Border.all(color: primaryColor.withOpacity(.4), width: 1),
                                            ),
                                            constraints: BoxConstraints(
                                                maxWidth: textSize('${item.service!}: ${item.owner!}', const TextStyle(fontSize: 14, color: Colors.white)).width + 44
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${item.service!}: ${item.owner!}',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 14, color: Colors.white),
                                                  ),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      provider.deleteConnector(item.id!);
                                                      provider.update();
                                                    },
                                                    child: Container(
                                                        alignment: Alignment.centerRight,
                                                        width: 20,
                                                        child: const Icon(Icons.close_sharp, size: 20, color: Colors.white)
                                                    )
                                                )
                                              ],
                                            )
                                        ) : const SizedBox.shrink();
                                      })
                                  ) : const Text(
                                    'text_select',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF728A9D)),
                                  ).tr()
                                ),
                                Transform.translate(
                                  offset: const Offset(8, 0),
                                  child: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF85A0AA),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'text_message',
                          style: TextStyle(fontSize: 14, color: secondColor),
                        ).tr(),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: width,
                          child: TextFormField(
                            controller: provider.controller5,
                            focusNode: provider.focus2,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: tr('text_message'),
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
                            keyboardType: TextInputType.text
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();

                            if (provider.controller.text != "" && provider.controller5.text != "" && provider.day.isNotEmpty && provider.connectors.isNotEmpty && (provider.controller2.text != '' && provider.controller3.text != '' || (provider.controller2.text != '' && provider.controller3.text == '') || (provider.controller2.text == '' && provider.controller3.text != ''))) {
                              provider.addResponder(id: widget.item?.id ?? 0).then((value) {
                                Navigator.of(Get.context!).pop();
                              });
                            }
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
                            'next',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ).tr(),
                        )
                      ],
                    ) : Container(
                        alignment: Alignment.center,
                        height: height,
                        child: const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(color: primaryColor)
                        )
                    )
                  )
              )
          );
        }
    );
  }
}