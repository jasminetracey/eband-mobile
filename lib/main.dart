import 'package:eband/router.dart';
import 'package:eband/screens/auth/auth_widget_builder.dart';
import 'package:eband/screens/screens.dart';
import 'package:eband/services/firebase_auth_service.dart';
import 'package:eband/utils/app_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseAuthService>(
          create: (context) => FirebaseAuthService(),
        ),
      ],
      child: EbandApp(),
    ),
  );
}

class EbandApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthWidgetBuilder(
      builder: (context, userSnapshot) {
        return MaterialApp(
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
          ],
          theme: appTheme(context),
          debugShowCheckedModeBanner: false,
          title: 'Eband App',
          onGenerateRoute: Router.onGenerateRoute,
          home: (userSnapshot?.data?.uid != null)
              ? const HomeUI()
              : LoginScreen(),
        );
      },
    );
  }
}
