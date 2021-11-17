import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/src/screen/base_component/bottom_bar/tab_item.dart';

class CustomBottomBarComponent extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> createdScreen;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CustomBottomBarComponent({
    Key? key,
    required this.navigatorKeys,
    required this.createdScreen,
    required this.currentTab,
    required this.onSelectedTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _createNavigationBarItem(TabItem.users),
          _createNavigationBarItem(TabItem.profile),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final showedItem = TabItem.values[index];

        return CupertinoTabView(
            navigatorKey: navigatorKeys[showedItem],
            builder: (context) {
              return createdScreen[showedItem]!;
            });
      },
    );
  }

  BottomNavigationBarItem _createNavigationBarItem(TabItem tabItem) {
    final createdTab = TabItemData.allTabs[tabItem];

    return BottomNavigationBarItem(
        icon: Icon(createdTab!.icon), label: createdTab.title);
  }
}
