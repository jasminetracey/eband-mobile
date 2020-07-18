import 'package:eband/models/user.dart';
import 'package:eband/services/firebase_auth_service.dart';
import 'package:eband/services/firebase_storage_service.dart';
import 'package:eband/services/firestore_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//https://www.youtube.com/watch?v=B0QX2woHxaU from this tutorial
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<FirebaseUser>) builder;

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    return StreamBuilder<FirebaseUser>(
      stream: authService.user,
      builder: (context, snapshot) {
        final FirebaseUser user = snapshot.data;
        if (user != null) {
          /*
          * For any other Provider services that rely on user data can be
          * added to the following MultiProvider list.
          * Once a user has been detected, a re-build will be initiated.
           */
          return MultiProvider(
            providers: [
              Provider<FirebaseUser>.value(value: user),
              StreamProvider<User>.value(
                value: FirebaseAuthService().streamFirestoreUser(user),
              ),
              Provider<FirestoreDatabase>(
                create: (_) => FirestoreDatabase(uid: user.uid),
              ),
              Provider<FirebaseStorageService>(
                create: (_) => FirebaseStorageService(),
              )
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
