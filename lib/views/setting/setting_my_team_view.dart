import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/models/setting_my_team_response_model.dart';
import 'package:x_hub/other/constant.dart';
import 'package:x_hub/views/setting/setting_add_team_bottom_sheet_view.dart';
import 'package:get/route_manager.dart';
import '../../other/extensions.dart';
import '../../provider/setting_my_team_provider.dart';

class SettingMyTeamView extends StatefulWidget {
  const SettingMyTeamView({super.key});

  @override
  State<SettingMyTeamView> createState() => _SettingMyTeamViewState();
}

class _SettingMyTeamViewState extends State<SettingMyTeamView> {

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    await Provider.of<SettingMyTeamProvider>(Get.context!, listen: false).getMyTeam();
  }

  @override
  void dispose() {
    Provider.of<SettingMyTeamProvider>(Get.context!, listen: false).resetParams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - 60;

    return Consumer<SettingMyTeamProvider>(
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
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          'text_my_team',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2c3e50)),
                        ).tr(),
                        Container(
                            alignment: Alignment.centerRight,
                            width: 50,
                            child: InkWell(
                              onTap: () {
                                provider.setSubmit(false);
                                showModalBottomSheet(context: context, backgroundColor: Colors.white, isScrollControlled: true, builder: (context) {
                                  return const SettingAddTeamBottomSheetView();
                                });
                              },
                              child: const Icon(Icons.add),
                            )
                        )
                      ],
                    )
                ),
              ),
              body: SafeArea(
                  child: Container(
                      alignment: provider.myTeam.isNotEmpty ? Alignment.topLeft : Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: provider.isLoader ? provider.myTeam.isNotEmpty ? ListView.separated(
                        itemCount: provider.myTeam.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(thickness: .1);
                        },
                        itemBuilder: (context, index) {
                          final TeamItem team = provider.myTeam[index];

                          return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Slidable(
                                  key: const ValueKey(1),
                                  endActionPane: team.status != 2 ? ActionPane(
                                    dragDismissible: false,
                                    extentRatio: 0.20,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                          onPressed: (BuildContext context) {
                                            snackBar(text: tr('text_remove_connected'), title: tr('text_alert'), next: tr('text_delete'), callback: () {
                                              provider.deleteMyTeam(team.email!).then((value) => Get.back());
                                            });
                                          },
                                          backgroundColor: removeColor,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete
                                      ),
                                    ],
                                  ) : null,
                                  child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              team.email!,
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2c3e50)),
                                            ),
                                            Text(
                                              provider.getStatus(team.status!),
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF2c3e50)),
                                            ),
                                          ],
                                        ),
                                        Transform.translate(
                                            offset: const Offset(6, 0),
                                            child: Container(width: 6, height: 30, color: Colors.white)
                                        )
                                      ]
                                  )
                              )
                          );
                        },
                      ) : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Text(
                              'text_team_empty',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)
                          ).tr()
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