import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';

class AddRoomPage extends StatefulWidget {
  @override
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state){
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: state.themeData.primaryColor,
                title: Text("Add Room", style: state.themeData.textTheme.headline),
              ),
            ),
          );
        }
    );
  }
}
