import 'package:eband/router.dart';
import 'package:eband/screens/screens.dart';
import 'package:eband/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrganizerTabScreen extends StatelessWidget {
  OrganizerTabScreen({Key key}) : super(key: key);

  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageController,
          children: <Widget>[
            OrganizerEventsScreen(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          child: const Icon(
            Icons.add,
            color: AppColors.whiteColor,
          ),
          onPressed: () =>
              Navigator.pushNamed(context, Routes.organizerAddEventRoute),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 7.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: FaIcon(FontAwesomeIcons.calendarAlt),
                onPressed: () {
                  pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              ),
            ],
          ),
        ));
  }
}
