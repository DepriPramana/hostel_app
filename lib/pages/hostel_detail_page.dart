import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/model/hostel.dart';

import 'add_room_page.dart';

class HostelDetailPage extends StatefulWidget {

  final List<Hostels> data;
  int index;

  HostelDetailPage(this.data, this.index);

  @override
  _HostelDetailPageState createState() => _HostelDetailPageState();
}

class _HostelDetailPageState extends State<HostelDetailPage> {

  String _userPic = "";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future getUserData() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference reference = await FirebaseDatabase.instance.reference().child("Users");
    reference.child(currentUser.uid).child("profile_pic").once().then((DataSnapshot snapshot){
      setState(() {
        _userPic = snapshot.value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState state) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Hero(
                            tag: widget.data[widget.index].hostel_pic,
                            child: FadeInImage(
                              width: double.infinity,
                              height: double.infinity,
                              image: NetworkImage(widget.data[widget.index].hostel_pic,),
                              fit: BoxFit.cover,
                              placeholder:
                              AssetImage('assets/loading.gif'),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                    begin: FractionalOffset.bottomCenter,
                                    end: FractionalOffset.topCenter,
                                    colors: [
                                      state.themeData.accentColor,
                                      state.themeData.accentColor.withOpacity(0.3),
                                      state.themeData.accentColor.withOpacity(0.2),
                                      state.themeData.accentColor.withOpacity(0.1),
                                    ],
                                    stops: [
                                      0.0,
                                      0.25,
                                      0.5,
                                      0.75
                                    ])),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: state.themeData.accentColor,
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: state.themeData.accentColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddRoomPage()));
                          },
                          child: Text("Add Room", style: state.themeData.textTheme.headline),
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Stack(
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 75, 16, 16),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  color: state.themeData.primaryColor,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 120.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                widget.data[widget.index].hostel_name,
                                                style: state
                                                    .themeData.textTheme.headline,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "5",
                                                      style: state
                                                          .themeData.textTheme.body2,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.green,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                                                  child:  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        'Facilities',
                                                        style: state
                                                            .themeData.textTheme.body1,
                                                      ),
                                                      SizedBox(height: 10.0),
                                                      Container(
                                                        child: Text(
                                                          widget.data[widget.index].hostel_facilities,
                                                          style: state
                                                              .themeData.textTheme.caption,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Location: ',
                                                          style: state
                                                              .themeData.textTheme.body2,
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        Flexible(
                                                          child: Text(
                                                            widget.data[widget.index].location_name,
                                                            style: state
                                                                .themeData.textTheme.caption,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Provider Name: ',
                                                          style: state
                                                              .themeData.textTheme.body2,
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        Flexible(
                                                          child: Text(
                                                            widget.data[widget.index].provider_name,
                                                            style: state
                                                                .themeData.textTheme.caption,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'No of Rooms: ',
                                                          style: state
                                                              .themeData.textTheme.body2,
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        Flexible(
                                                          child: Text(
                                                            widget.data[widget.index].no_of_room,
                                                            style: state
                                                                .themeData.textTheme.caption,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Price Per Head: ',
                                                          style: state
                                                              .themeData.textTheme.body2,
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        Flexible(
                                                          child: Text(
                                                            widget.data[widget.index].price_per_head,
                                                            style: state
                                                                .themeData.textTheme.caption,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          'Contact No: ',
                                                          style: state
                                                              .themeData.textTheme.body2,
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        Flexible(
                                                          child: Text(
                                                            widget.data[widget.index].contact_number,
                                                            style: state
                                                                .themeData.textTheme.caption,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.0),
                                                  ],
                                                )
                                              ),
//                                          ScrollingArtists(
//                                            api: Endpoints.getCreditsUrl(
//                                                widget.movie.id),
//                                            title: 'Cast',
//                                            tapButtonText: 'See full cast & crew',
//                                            themeData: widget.themeData,
//                                            onTap: (Cast cast) {
//                                              modalBottomSheetMenu(cast);
//                                            },
//                                          ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 40,
                              child: SizedBox(
                                width: 100,
                                height: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: FadeInImage(
                                    image: NetworkImage(_userPic),
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage(
                                        'assets/loading.gif'),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
