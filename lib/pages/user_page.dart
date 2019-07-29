import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/model/hostel.dart';
import 'package:hostel_app/pages/room_search.dart';
import 'package:hostel_app/pages/settings_two.dart';
import 'package:hostel_app/services/auth.dart';
import 'package:hostel_app/widget/by_facilities_rooms_page.dart';
import 'package:hostel_app/widget/by_place_hostels.dart';
import 'package:hostel_app/widget/by_price_rooms.dart';
import 'package:hostel_app/widget/discover_hostels.dart';

class UserPage extends StatefulWidget {

  final ChangeThemeState state;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  UserPage({this.state, this.auth, this.onSignedOut});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return SafeArea(
            child: Scaffold(
              drawer: Drawer(
                  child: SettingsPageTwo()
              ),
              appBar: AppBar(
                backgroundColor: widget.state.themeData.primaryColor,
                title: Text('Room Sharing App',
                    style: widget.state.themeData.textTheme.body1),
                actions: <Widget>[
                  IconButton(
                    onPressed: () async {
                      final Hostels result = await showSearch(context: context, delegate: RoomSearch(
                          themeData: widget.state.themeData,
                      ));
                    },
                    icon: Icon(Icons.search, color: widget.state.themeData.splashColor),
                  ),
                ],
              ),
              body: Container(
                color: state.themeData.primaryColor,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    DiscoverHostels(state),
                    ByPlaceHostels(state),
                    ByPriceRooms(state),
                    ByFacilitiesRooms(state),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
