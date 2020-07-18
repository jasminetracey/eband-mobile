import 'package:eband/models/user.dart';
import 'package:eband/router.dart';
import 'package:eband/screens/components/platform_exception_alert_dialog.dart';
import 'package:eband/utils/app_helpers.dart';
import 'package:eband/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _firstName, _lastName, _email, _password;
  UserType _userType;

  void _handleRadioValueChange(UserType value) {
    setState(() {
      _userType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: UserType.patron,
                      groupValue: _userType,
                      onChanged: _handleRadioValueChange,
                    ),
                    const Text(
                      'Patron',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                      value: UserType.organizer,
                      groupValue: _userType,
                      onChanged: _handleRadioValueChange,
                    ),
                    const Text(
                      'Organizer',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                verticalSpaceSmall(context),
                TextFormField(
                  keyboardType: TextInputType.text,
                  onSaved: (value) => _firstName = value,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person_outline),
                    labelText: 'First Name*',
                  ),
                ),
                verticalSpaceSmall(context),
                TextFormField(
                  keyboardType: TextInputType.text,
                  onSaved: (value) => _lastName = value,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person_outline),
                    labelText: 'Last Name*',
                  ),
                ),
                verticalSpaceSmall(context),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _email = value,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.mail),
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
                  onPressed: () => register(),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                verticalSpaceMedium(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Already have an Account ? ',
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, Routes.loginRoute),
                      child: Text(
                        'Sign In',
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

  Future<void> register() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        final auth = Provider.of<FirebaseAuthService>(context, listen: false);
        await auth.createUserWithEmailAndPassword(
            _email, _password, _firstName, _lastName, _userType);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Registration failed',
          exception: e,
        );
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
