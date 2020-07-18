import 'package:eband/router.dart';
import 'package:eband/screens/components/platform_exception_alert_dialog.dart';
import 'package:eband/services/firebase_auth_service.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        minimum: kSafeArea,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                verticalSpaceMedium(context),
                TextFormField(
                  onSaved: (value) => _email = value,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Email*',
                  ),
                ),
                verticalSpaceSmall(context),
                TextFormField(
                  obscureText: true,
                  onSaved: (value) => _password = value,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Password*',
                  ),
                ),
                verticalSpaceMedium(context),
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: const EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () => login(),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                verticalSpaceMedium(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Don't have an Account ? ",
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, Routes.signUpRoute),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        final auth = Provider.of<FirebaseAuthService>(context, listen: false);
        await auth.signInWithEmailAndPassword(_email, _password);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Sign in failed',
          exception: e,
        );
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
