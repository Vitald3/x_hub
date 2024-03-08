import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import '../../models/filters_response_model.dart';
import '../../provider/filters_provider.dart';

class FiltersView extends StatelessWidget {
  const FiltersView({super.key, required this.filters});

  final Filters filters;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer<FiltersProvider>(builder: (context, provider, _) {
      return Wrap(
        children: [
          Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'text_filters',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                  ).tr(),
                  if(filters.accounts != null && filters.accounts!.isNotEmpty) const SizedBox(height: 20),
                  if(filters.accounts != null && filters.accounts!.isNotEmpty) const Text(
                    'text_conversation',
                    style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                  ).tr(),
                  if(filters.accounts != null && filters.accounts!.isNotEmpty) DropdownButton<String>(
                    isExpanded: true,
                    value: provider.selected,
                    icon: const Icon(Icons.arrow_drop_down),
                    hint: const Text(
                      'text_select',
                      style: TextStyle(fontSize: 13, color: Color(0xFF2c3e50)),
                    ).tr(),
                    style: const TextStyle(color: Color(0xFF2c3e50)),
                    onChanged: (String? value) {
                      provider.setSelected(value);
                    },
                    items: filters.accounts!.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  if(filters.sharedWith != null && filters.sharedWith!.isNotEmpty) const SizedBox(height: 10),
                  if(filters.sharedWith != null && filters.sharedWith!.isNotEmpty) const Text(
                    'text_shared',
                    style: TextStyle(fontSize: 16, color: Color(0xFF2c3e50)),
                  ).tr(),
                  if(filters.sharedWith != null && filters.sharedWith!.isNotEmpty) DropdownButton<String>(
                    isExpanded: true,
                    value: provider.selected2,
                    icon: const Icon(Icons.arrow_drop_down),
                    hint: const Text(
                      'text_select',
                      style: TextStyle(fontSize: 13, color: Color(0xFF2c3e50)),
                    ).tr(),
                    style: const TextStyle(color: Color(0xFF2c3e50)),
                    onChanged: (String? value) {
                      provider.setSelected2(value);
                    },
                    items: filters.sharedWith!.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          provider.chatList(true, context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2c3e50),
                            elevation: 0,
                            minimumSize: Size((width/2)-23, 38)
                        ),
                        child: const Text(
                          'text_reset',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ).tr(),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          provider.chatList(false, context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0,
                            minimumSize: Size((width/2)-23, 38)
                        ),
                        child: const Text(
                          'text_submit',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ).tr(),
                      ),
                    ],
                  )
                ],
              )
          )
        ],
      );
    });
  }
}