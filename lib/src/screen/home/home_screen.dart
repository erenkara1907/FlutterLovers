import 'package:flutter/material.dart';
import 'package:flutter_lovers/src/screen/base_component/bottom_bar/custom_bottom_bar_component.dart';
import 'package:flutter_lovers/src/screen/base_component/bottom_bar/tab_item.dart';
import 'package:flutter_lovers/src/screen/profile/profile_screen.dart';
import 'package:flutter_lovers/src/screen/user/user_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabItem _currentTab = TabItem.users;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.users: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allScreens() {
    return {
      TabItem.users: const UserScreen(),
      TabItem.profile: const ProfileScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CustomBottomBarComponent(
        currentTab: _currentTab,
        onSelectedTab: (selectedTab) {

          if(selectedTab == _currentTab){
            navigatorKeys[selectedTab]!.currentState!.popUntil((route) => route.isFirst);
          }

          setState(() {
            _currentTab = selectedTab;
          });
        },
        createdScreen: allScreens(),
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
