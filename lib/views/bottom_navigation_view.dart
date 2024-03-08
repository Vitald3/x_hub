import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../other/constant.dart';
import '../provider/main_layout_provider.dart';

class BottomNavigationView extends StatelessWidget {
  const BottomNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainLayoutProvider>(
        builder: (context, provider, _) {
          return BottomNavigationBar(
            selectedFontSize: 0,
            backgroundColor: Colors.white,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.black,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                  icon: Icon(
                      Icons.chat
                  ),
                  label: ""
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/images/2.svg', semanticsLabel: 'Responder', width: 26, height: 26, colorFilter: ColorFilter.mode(provider.activeTab == 1 ? primaryColor : Colors.black, BlendMode.srcIn)),
                  label: ""
              ),
              const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                  ),
                  label: ""
              )
            ],
            currentIndex: provider.activeTab,
            onTap: provider.onItemTapped,
          );
        }
    );
  }
}