import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';

class SettingsPageTwo extends StatefulWidget {
  @override
  _SettingsPageTwoState createState() => _SettingsPageTwoState();
}

class _SettingsPageTwoState extends State<SettingsPageTwo> {
  int option;
  final List<Color> colors = [Colors.white, Color(0xff242248), Colors.black];
  final List<Color> borders = [Colors.black, Colors.white, Colors.white];
  final List<String> themes = ['Light', 'Dark', 'Amoled'];

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  String profileName, profileImage, profileEmail;

  Future loadProfileData() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference reference = await FirebaseDatabase.instance.reference();
    reference
        .child("Users")
        .child(currentUser.uid)
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        profileEmail = snapshot.value["email"].toString();
        profileName = snapshot.value["first_name"].toString() +
            " " +
            snapshot.value["last_name"].toString();
        profileImage = snapshot.value["profile_pic"].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState state) {
        return Theme(
            data: state.themeData,
            child: Container(
              color: state.themeData.primaryColor,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: UserAccountsDrawerHeader(
                      decoration:
                          BoxDecoration(color: state.themeData.splashColor),
                      accountName: Text(
                          profileName == null ? "Loading..." : profileName,
                          style: state.themeData.textTheme.display1),
                      accountEmail: Text(
                          profileEmail == null ? "Loading..." : profileEmail,
                          style: state.themeData.textTheme.display2),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: state.themeData.primaryColor,
                        foregroundColor: state.themeData.primaryColor,
                        radius: 40.0,
                        backgroundImage: profileImage == null
                            ? AssetImage('assets/loading.gif')
                            : NetworkImage(profileImage),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.bottomCenter,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Theme',
                              style: state.themeData.textTheme.body2,
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
                                            style:
                                                state.themeData.textTheme.body2)
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
                                              child:
                                                  state.themeData.primaryColor ==
                                                          colors[index]
                                                      ? Icon(Icons.done,
                                                          color: state.themeData
                                                              .accentColor)
                                                      : Container(),
                                            ),
                                          ),
                                        ),
                                        Text(themes[index],
                                            style:
                                                state.themeData.textTheme.body2)
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}
