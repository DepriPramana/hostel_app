import 'package:flutter/material.dart';
import 'package:hostel_app/model/hostel.dart';
import 'package:hostel_app/widget/search_room.dart';

class RoomSearch extends SearchDelegate<Hostels> {
  final ThemeData themeData;

  RoomSearch({this.themeData});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = themeData.copyWith(
        hintColor: themeData.accentColor,
        cursorColor: themeData.accentColor,
        primaryColor: themeData.primaryColor,
        textTheme: TextTheme(
          title: themeData.textTheme.body2,
        ));
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: themeData.accentColor,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: themeData.accentColor,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchRoom(
      themeData: themeData,
      query: query,
      onTap: (hostels) {
        close(context, hostels);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: themeData.primaryColor,
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.search,
                  size: 50,
                  color: themeData.accentColor,
                ),
              ),
              Text('Search hostel or room', style: themeData.textTheme.body2)
            ],
          )),
    );
  }
}
