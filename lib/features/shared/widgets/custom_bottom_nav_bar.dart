import 'package:flutter/material.dart';
import 'package:paganini_wallet/core/constants/constants.dart';
import "package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart";
import 'package:icons_flutter/icons_flutter.dart';

class CustomPersistentNavBar extends StatelessWidget {
  final BuildContext context;
  final PersistentTabController controller;
  final List<Widget> screens;

  const CustomPersistentNavBar({
    super.key,
    required this.context,
    required this.controller,
    required this.screens,
  });

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(MfgLabs.home),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: Colors.grey,
          iconSize: 35),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.list_alt_rounded),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: Colors.grey,
          iconSize: 40),
      PersistentBottomNavBarItem(
        icon: const Icon(FlutterIcons.qrcode_scan_mco, color: Colors.white),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(FlutterIcons.credit_card_alt_faw),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
        iconSize: 30,
      ),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          activeColorPrimary: primaryColor,
          inactiveColorPrimary: Colors.grey,
          iconSize: 38),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: screens,
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      navBarStyle: NavBarStyle.style15,
      hideNavigationBarWhenKeyboardAppears: true,
      resizeToAvoidBottomInset: true,
      animationSettings: NavBarAnimationSettings(
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
              animateTabTransition: true,
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.slide,
              curve: Curves.linearToEaseOut)),
    );
  }
}
