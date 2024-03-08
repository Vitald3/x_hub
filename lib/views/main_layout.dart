import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/views/responder/responder_view.dart';
import 'package:x_hub/views/setting/setting_view.dart';
import '../provider/main_layout_provider.dart';
import 'chat/chat_list_view.dart';

class MainLayoutView extends StatelessWidget {
  MainLayoutView({super.key, this.index});

  final int? index;

  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>()
  };

  final List<Widget> _widgetOptions = <Widget>[
    const ChatListView(),
    const ResponderView(),
    const SettingView()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainLayoutProvider>(
        builder: (context, provider, _) {
          return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
              child: buildNavigator(provider)
          );
        }
    );
  }

  buildNavigator(MainLayoutProvider provider) {
    int act = provider.activeTab;

    if (!provider.reset && index != null) {
      act = index!;
      WidgetsBinding.instance.addPostFrameCallback((_) => provider.resetV());
    }

    return Navigator(
      key: navigatorKeys[act],
      onGenerateRoute: (RouteSettings settings) {
        return CupertinoPageRoute(builder: (_) => _widgetOptions.elementAt(act));
      },
    );
  }
}