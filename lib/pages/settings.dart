import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int option;
  final List<Color> colors = [Colors.white, Color(0xff242248), Colors.black];
  final List<Color> borders = [Colors.black, Colors.white, Colors.white];
  final List<String> themes = ['Light', 'Dark', 'Amoled'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          height: 150.0,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Themes',
                  style: state.themeData.textTheme.display1,
                ),
              ],
            ),
            subtitle: SizedBox(
              height: 100,
              child: Center(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2,
                                        color: borders[index]),
                                    color: colors[index]),
                              ),
                            ),
                            Text(themes[index],
                                style: state.themeData.textTheme.display1)
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    switch (index) {
                                      case 0:
                                        changeThemeBloc
                                            .onLightThemeChange();
                                        break;
                                      case 1:
                                        changeThemeBloc
                                            .onDarkThemeChange();
                                        break;
                                      case 2:
                                        changeThemeBloc
                                            .onAmoledThemeChange();
                                        break;
                                    }
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: state.themeData.primaryColor ==
                                      colors[index]
                                      ? Icon(Icons.done,
                                      color: state
                                          .themeData.accentColor)
                                      : Container(),
                                ),
                              ),
                            ),
                            Text(themes[index],
                                style: state.themeData.textTheme.display1)
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
