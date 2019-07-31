import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';

class MyRoomPage extends StatefulWidget {
  @override
  _MyRoomPageState createState() => _MyRoomPageState();
}

class _MyRoomPageState extends State<MyRoomPage> {

  bool _isLoading = false;
  String hosteName = "", userName = "", roomNumber = "", roomPrice = "", userPic = "", roomId = "", providerId = "";

  @override
  void initState() {
    super.initState();
    fetchRoom();
  }

  Future fetchRoom() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference reference = await FirebaseDatabase.instance.reference();
    reference.child("Booked").child(currentUser.uid.toString()).once().then((DataSnapshot snapshot){
      setState(() {
        hosteName = snapshot.value["hostel_name"];
        userName = snapshot.value["user_name"];
        roomNumber = snapshot.value["room_number"];
        roomId = snapshot.value["room_id"];
        providerId = snapshot.value["provider_id"];
        roomPrice = snapshot.value["room_price"];
        userPic = snapshot.value["user_pic"];
      });
    });
  }

  Future leaveRoom() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference reference2 = await FirebaseDatabase.instance.reference();
    DatabaseReference reference3 = await FirebaseDatabase.instance.reference();
    DatabaseReference reference1 =
    await FirebaseDatabase.instance.reference();
    Map<String, dynamic> data1 = {"request_type": "not_requested"};
    reference1
        .child("Rooms")
        .child(roomId)
        .update(data1)
        .whenComplete(() {
      reference2.child("Booked").child(currentUser.uid.toString()).remove().whenComplete((){
        reference3.child("Booked").child(providerId).remove().whenComplete((){
          _isLoading = false;
          setState(() {

          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: state.themeData.primaryColor,
              title: Text("Room Sharing App", style: state.themeData.textTheme.body1),
            ),
            body: userPic == "" ? Container() : Container(
              margin: EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 170,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: state.themeData.primaryColor,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                  width: 1,
                                  color: state.themeData.accentColor)),
                          height: 170,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 115.0, top: 5.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    hosteName,
                                    style:
                                    state.themeData.textTheme.body1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        userName,
                                        style: state.themeData
                                            .textTheme.caption,
                                      ),
                                      SizedBox(width: 10.0, height: 5.0),
                                      Text(
                                        "Room No " + roomNumber + " PKR " +
                                            roomPrice,
                                        style: state.themeData.textTheme
                                            .caption,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                                  child: _isLoading ? Container(width: 30.0, height: 30.0 ,child: CircularProgressIndicator()) : FlatButton(
                                    onPressed: leaveRoom,
                                    child: Text("LEAVE", style: state.themeData.textTheme.caption),
                                    color: Colors.cyan,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 8,
                        child: SizedBox(
                          width: 100,
                          height: 125,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage(
                              image: NetworkImage(
                                  userPic),
                              fit: BoxFit.cover,
                              placeholder:
                              AssetImage('assets/loading.gif'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          );
        });
  }
}
