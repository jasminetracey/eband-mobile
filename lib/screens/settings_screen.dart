import 'package:eband/screens/components/rounded_button.dart';
import 'package:eband/utils/app_colors.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        minimum: kSafeArea,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Update Profile'),
              trailing: RoundedButton(
                onPressed: () {},
                text: 'Update Profile',
              ),
            ),
            ListTile(
              title: const Text('Sign Out'),
              trailing: RoundedButton(
                onPressed: () {
                  final _auth =
                      Provider.of<FirebaseAuthService>(context, listen: false);
                  _auth.signOut();
                },
                text: 'Sign Out',
              ),
            )
          ],
        ),
      ),
    );
  }
}
