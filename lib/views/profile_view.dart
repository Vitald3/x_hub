import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import '../other/constant.dart';
import '../provider/profile_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    Provider.of<ProfileProvider>(Get.context!, listen: false).getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 30;

    return Consumer<ProfileProvider>(
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
                          'text_profile',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                        ).tr(),
                        Container(
                            alignment: Alignment.centerRight,
                            width: 70,
                            child: InkWell(
                              onTap: () {
                                provider.update();
                              },
                              child: const Icon(Icons.check),
                            )
                        )
                      ],
                    )
                )
              ),
              body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: provider.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('text_firstname').tr(),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: width,
                            child: TextFormField(
                                controller: provider.firstname,
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
                                  hintText: tr('text_firstname'),
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
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('text_lastname').tr(),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: width,
                            child: TextFormField(
                                controller: provider.lastname,
                                focusNode: provider.focus2,
                                autocorrect: false,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (val) {
                                  if (val == "") {
                                    return tr('field_required');
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: tr('text_lastname'),
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
                                    )
                                ),
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('text_company').tr(),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: width,
                            child: TextFormField(
                                controller: provider.company,
                                autocorrect: false,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                    hintText: tr('text_company'),
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
                                    )
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('text_nip').tr(),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: width,
                            child: TextFormField(
                                controller: provider.nip,
                                focusNode: provider.focus3,
                                autocorrect: false,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (val) {
                                  if (val != "" && (val!.length != 10 || !provider.isNumeric(val))) {
                                    return tr('text_error_nip');
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: tr('text_nip'),
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
                                    )
                                ),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('text_address').tr(),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: width,
                            child: TextFormField(
                                controller: provider.address,
                                focusNode: provider.focus4,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                autocorrect: false,
                                validator: (val) {
                                  if (val == "") {
                                    return tr('field_required');
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: tr('text_address'),
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
                                    )
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('text_city').tr(),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: width,
                            child: TextFormField(
                                controller: provider.city,
                                focusNode: provider.focus5,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                autocorrect: false,
                                validator: (val) {
                                  if (val == "") {
                                    return tr('field_required');
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: tr('text_city'),
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
                                    )
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('text_zip').tr(),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: width,
                            child: TextFormField(
                                controller: provider.zip,
                                focusNode: provider.focus6,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                autocorrect: false,
                                validator: (val) {
                                  if (val == "") {
                                    return tr('field_required');
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: tr('text_zip'),
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
                                    )
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('text_country').tr(),
                          const SizedBox(height: 10),
                          DropdownButton<String?>(
                              isExpanded: true,
                              value: provider.country,
                              icon: const Icon(Icons.arrow_drop_down),
                              hint: const Text(
                                'text_select',
                                style: TextStyle(fontSize: 13, color: Color(0xFF2c3e50)),
                              ).tr(),
                              style: const TextStyle(color: Color(0xFF2c3e50)),
                              onChanged: (String? value) {
                                provider.setCountry(value!);
                              },
                              items: List.generate(provider.countries.length, (index) {
                                return DropdownMenuItem<String?>(
                                  value: provider.countries[index],
                                  child: Text(provider.countries[index]),
                                );
                              })
                          ),
                          const SizedBox(height: 20)
                        ],
                      )
                    )
                  ),
                ),
              )
          );
        }
    );
  }
}