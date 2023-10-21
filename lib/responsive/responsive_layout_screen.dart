import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget WebScreenLayout;
  final Widget MobileScreenLayout;

  ResponsiveLayout(
      {super.key,
      required this.WebScreenLayout,
      required this.MobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          //web screen
          return widget.WebScreenLayout;
        }
        //mobile screen
        return widget.MobileScreenLayout;
      },
    );
  }
}
