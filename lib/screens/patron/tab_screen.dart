import 'package:eband/models/user.dart';
import 'package:eband/screens/screens.dart';
import 'package:eband/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PatronTabScreen extends StatefulWidget {
  const PatronTabScreen({Key key}) : super(key: key);

  @override
  _PatronTabScreenState createState() => _PatronTabScreenState();
}

class _PatronTabScreenState extends State<PatronTabScreen> {
  int _currentIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          pageChanged(index);
        },
        children: <Widget>[
          UpcomingEventsScreen(),
          PatronEventsScreen(),
          if (user.wristband != null) WristbandDetailsScreen(),
          if (user.wristband == null) WristbandOrderScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if ((_currentIndex - index).abs() == 1) {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            } else {
              pageController.jumpToPage(index);
            }
          });
        },
        selectedItemColor: AppColors.primaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: AppColors.iconColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: const Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.ticketAlt),
            title: const Text('My Events'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.ring),
            title: const Text('Wristbands'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.add_shopping_cart),
          //   title: const Text('Transactions'),
          // ),
          // BottomNavigationBarItem(
          //   icon: FaIcon(FontAwesomeIcons.userCircle),
          //   title: const Text('Account'),
          // ),
        ],
      ),
    );
  }
}
