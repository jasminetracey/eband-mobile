import 'package:eband/models/user.dart';
import 'package:eband/screens/screens.dart';
import 'package:eband/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeUI extends StatelessWidget {
  const HomeUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);

    if (user != null) {
      if (user.userType == 'UserType.patron') {
        return const PatronTabScreen();
      }
      if (user.userType == 'UserType.organizer') {
        return OrganizerTabScreen();
      }
      auth.signOut();
    }
    return Container();
  }
}
