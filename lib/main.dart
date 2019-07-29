import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/services/auth.dart';

import 'bloc/change_theme_bloc.dart';
import 'bloc/change_theme_state.dart';
import 'pages/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Colors.blue, canvasColor: Colors.transparent),
            title: 'Room Sharing App',
              home: RootPage(auth: new Auth())
          );
        }
    );
  }
}
