import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';

import 'add_data_page.dart';

class HostelPage extends StatefulWidget {
  @override
  _HostelPageState createState() => _HostelPageState();
}

class _HostelPageState extends State<HostelPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: state.themeData.primaryColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddDataPage()));
              },
              child: Icon(Icons.add, color: state.themeData.accentColor),
            ),
          );
        });
  }
}
