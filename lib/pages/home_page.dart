import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/pages/edit_page.dart';
import 'package:hostel_app/pages/provider_page.dart';
import 'package:hostel_app/pages/user_page.dart';
import 'package:hostel_app/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isEmailVerified = false;
  String userId = "";
  String userType = "";

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    checkStatus();
    checkUserType();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String status = "no";
  checkStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      status = sharedPreferences.getString("status");
    });
    print(status);
  }

  checkUserType() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    userId = currentUser.uid;
    DatabaseReference reference = await FirebaseDatabase.instance.reference();
    reference
        .child("Users")
        .child(userId)
        .child("userType")
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        userType = snapshot.value.toString();
        reference.keepSynced(true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return SafeArea(
            child: status == "yes"
                ? EditPage()
                : userType == "Provider"
                    ? ProviderPage()
                    : UserPage(state: state)
          );
        });
  }
}
