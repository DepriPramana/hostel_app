import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/model/hostel.dart';

import 'add_data_page.dart';
import 'hostel_detail_page.dart';

class HostelPage extends StatefulWidget {
  @override
  _HostelPageState createState() => _HostelPageState();
}

class _HostelPageState extends State<HostelPage> {
  List<Hostels> _hostelList = [];

  Future fetchHostels() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    Query reference =
        await FirebaseDatabase.instance.reference().child("Hostels").orderByChild("provider_id").equalTo(currentUser.uid);
    reference.once().then((DataSnapshot snapshot) {
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      _hostelList.clear();
      for (var singleKey in keys) {
        Hostels hostels = new Hostels(
          data[singleKey]["contact_number"],
          data[singleKey]["hostel_facilities"],
          data[singleKey]["hostel_id"],
          data[singleKey]["hostel_name"],
          data[singleKey]["hostel_pic"],
          data[singleKey]["location_name"],
          data[singleKey]["no_of_room"],
          data[singleKey]["price_per_head"],
          data[singleKey]["provider_id"],
          data[singleKey]["provider_name"],
        );
        _hostelList.add(hostels);
        reference.keepSynced(true);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHostels();
  }

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
            body: Container(
              color: state.themeData.primaryColor.withOpacity(0.8),
              child: _hostelList == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: _hostelList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HostelDetailPage(
                                          data: _hostelList, index: index)));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200.0,
                                color: state.themeData.splashColor,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Hero(
                                          tag: _hostelList[index].hostel_pic,
                                          child:
                                              _hostelList[index].hostel_pic ==
                                                      null
                                                  ? Image.asset(
                                                      'assets/na.jpg',
                                                      fit: BoxFit.cover,
                                                    )
                                                  : FadeInImage(
                                                      image: NetworkImage(
                                                          _hostelList[index]
                                                              .hostel_pic),
                                                      fit: BoxFit.cover,
                                                      placeholder: AssetImage(
                                                          'assets/loading.gif'),
                                                    ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(_hostelList[index].hostel_name,
                                                  style: state.themeData.textTheme
                                                      .caption),
                                            ),
                                            Flexible(
                                              child: Text(
                                                  _hostelList[index]
                                                      .location_name,
                                                  style: state.themeData.textTheme
                                                      .caption),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
            ),
          );
        });
  }
}
