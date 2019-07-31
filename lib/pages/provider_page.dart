import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/model/request.dart';
import 'package:hostel_app/pages/request_page.dart';
import 'package:hostel_app/pages/settings_two.dart';

import 'hostel_page.dart';
import 'login_page.dart';

class ProviderPage extends StatefulWidget {

  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {

  int _count = 0;

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
  void initState() {
    super.initState();
    getRequestData();
  }

  Future getRequestData() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    Query reference = await FirebaseDatabase.instance.reference().child("Requests");
    reference.orderByChild("provider_id").equalTo(currentUser.uid.toString()).once().then((DataSnapshot snapshot){
      if(snapshot != null) {
        var keys = snapshot.value.keys;
        for (var singleKey in keys) {
          _count = _count + 1;
          reference.keepSynced(true);
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state){
          return DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Scaffold(
                drawer: Drawer(child: SettingsPageTwo()),
                appBar: AppBar(
                  backgroundColor: state.themeData.primaryColor,
                  title: Text('Room Sharing App',
                      style: state.themeData.textTheme.body1),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(40.0),
                    child: TabBar(
                      indicatorColor: state.themeData.accentColor,
                      tabs: <Widget>[Tab(text: "Rooms"), Tab(text: "User Request " + "($_count)")],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Logout',
                            style: state.themeData.textTheme.caption),
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
    );
  }
}
