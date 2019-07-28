import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/pages/request_page.dart';
import 'package:hostel_app/pages/settings_two.dart';

import 'add_data_page.dart';
import 'hostel_page.dart';
import 'login_page.dart';

class ProviderPage extends StatefulWidget {
  final ChangeThemeState state;
  ProviderPage({this.state});

  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
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
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          drawer: Drawer(child: SettingsPageTwo()),
          appBar: AppBar(
            backgroundColor: widget.state.themeData.primaryColor,
            title: Text('Hostel App',
                style: widget.state.themeData.textTheme.headline),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40.0),
              child: TabBar(
                indicatorColor: widget.state.themeData.accentColor,
                tabs: <Widget>[Tab(text: "Hostels"), Tab(text: "User Request")],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Logout',
                      style: widget.state.themeData.textTheme.caption),
                  onPressed: _signOut)
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              HostelPage(),
              RequestPage()
            ],
          ),
        ));
  }
}
