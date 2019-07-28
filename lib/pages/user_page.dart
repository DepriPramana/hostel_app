import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';

import 'login_page.dart';

class UserPage extends StatefulWidget {

  final ChangeThemeState state;
  UserPage({this.state});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  _signOut() async {
    try {
      FirebaseAuth mAuth = FirebaseAuth.instance;
      mAuth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (BuildContext context) => LoginSignUpPage()),
              (Route<dynamic> route) => false);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: widget.state.themeData.primaryColor,
        title: Text('Hostel App',
            style: widget.state.themeData.textTheme.headline),
        actions: <Widget>[
          FlatButton(
              child: Text('Logout',
                  style: widget.state.themeData.textTheme.caption),
              onPressed: _signOut)
        ],
      ),
    );
  }
}
