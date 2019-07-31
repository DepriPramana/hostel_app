import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/model/hostel.dart';
import 'package:hostel_app/model/rooms.dart';

class ScrollingRoomsPage extends StatefulWidget {
  final ChangeThemeState state;
  final List<Hostels> data;
  final int index;

  ScrollingRoomsPage(this.state, this.data, this.index);

  @override
  _ScrollingRoomsPageState createState() => _ScrollingRoomsPageState();
}

class _ScrollingRoomsPageState extends State<ScrollingRoomsPage> {
  List<Rooms> _roomsList = [];
  String _requestType = "";
  bool _isLoading = false;
  String _request = "BOOK NOW";
  Color _color = null;

  @override
  void initState() {
    super.initState();
    _getRoomsData();
    checkRequest();
//    checkRoomStatus();
  }

//  String _requestType2 = "";
//
//  Future checkRoomStatus() async {
//    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
//    DatabaseReference reference1 = await FirebaseDatabase.instance.reference();
//    reference1.child("Booked").child(currentUser.uid.toString()).child("request_type").once().then((DataSnapshot snapshot){
//      setState(() {
//        _requestType2 = snapshot.value.toString();
//      });
//    });
//  }

  Future checkRequest() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference reference1 = await FirebaseDatabase.instance.reference();
    reference1
        .child("Rooms")
        .child(currentUser.uid.toString()).child("request_type")
        .once()
        .then((DataSnapshot snap) {
      _requestType = snap.value.toString();
      switch(_requestType) {
        case "not_requested":
          setState(() {
            _request = "BOOK NOW";
            _requestType = "not_requested";
            _color = Colors.green;
          });
          break;
        case "requested":
          setState(() {
            _request = "CANCEL REQUEST";
            _requestType = "requested";
            _color = Colors.yellow;
          });
          break;
        case "accepted":
          setState(() {
            _request = "LEAVE ROOM";
            _requestType = "accepted";
            _color = Colors.white;
          });
          break;
        default:
          _requestType = "not_requested";
          _request = "BOOK NOW";
          _color = Colors.white;
      }
    });
  }

  Future _getRoomsData() async {
    Query reference = await FirebaseDatabase.instance
        .reference()
        .child("Rooms")
        .orderByChild("hostel_id")
        .equalTo(widget.data[widget.index].hostel_id);
    reference.once().then((DataSnapshot snapshot) {
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      _roomsList.clear();
      for (var singleKey in keys) {
        Rooms rooms = new Rooms(
          data[singleKey]["floor_num"],
          data[singleKey]["hostel_id"],
          data[singleKey]["occupancy"],
          data[singleKey]["request_type"],
          data[singleKey]["room_id"],
          data[singleKey]["room_num"],
          data[singleKey]["room_pic"],
        );
        reference.keepSynced(true);
        _roomsList.add(rooms);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Rooms", style: widget.state.themeData.textTheme.headline),
              Text(widget.data[widget.index].hostel_name,
                  style: widget.state.themeData.textTheme.caption),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 120,
          child: _roomsList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _roomsList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          modalBottomSheetMenu(index);
                        },
                        child: SizedBox(
                          width: 80,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                  width: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: _roomsList[index].room_pic == null
                                        ? Image.asset(
                                            'assets/na.jpg',
                                            fit: BoxFit.cover,
                                          )
                                        : FadeInImage(
                                            image: NetworkImage(
                                                _roomsList[index].room_pic),
                                            fit: BoxFit.cover,
                                            placeholder: AssetImage(
                                                'assets/loading.gif'),
                                          ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Room " + _roomsList[index].room_num,
                                  style:
                                      widget.state.themeData.textTheme.caption,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future bookNowRoom(int index1) async {
    setState(() {
      _isLoading = true;
    });
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String userName = "", userPic = "";
    if (_requestType == "not_requested") {
      DatabaseReference reference1 =
          await FirebaseDatabase.instance.reference();
      reference1
          .child("Users")
          .child(currentUser.uid)
          .once()
          .then((DataSnapshot snapshot) async {
        userName =
            snapshot.value["first_name"] + " " + snapshot.value["last_name"];
        userPic = snapshot.value["profile_pic"];
        DatabaseReference reference =
            await FirebaseDatabase.instance.reference();
        Map data = {
          "hostel_id": widget.data[widget.index].hostel_id,
          "provider_id": widget.data[widget.index].provider_id,
          "room_id": _roomsList[index1].room_id,
          "user_id": currentUser.uid.toString(),
          "request_type": "requested",
          "room_number": _roomsList[index1].room_num,
          "hostel_name": widget.data[widget.index].hostel_name,
          "room_price": widget.data[widget.index].price_per_head,
          "user_name": userName,
          "user_pic": userPic
        };
        reference
            .child("Requests")
            .child(currentUser.uid.toString())
            .set(data)
            .whenComplete(() async {
          DatabaseReference reference1 =
              await FirebaseDatabase.instance.reference();
          Map<String, dynamic> data1 = {"request_type": "requested"};
          reference1
              .child("Rooms")
              .child(_roomsList[index1].room_id)
              .update(data1)
              .whenComplete(() {
            _request = "CANCEL REQUEST";
            _requestType = "requested";
            _color = Colors.yellow;
            _isLoading = false;
            setState(() {
            });
          });
        });
        setState(() {});
      });
    }
    if (_requestType == "requested") {
      DatabaseReference reference = await FirebaseDatabase.instance.reference();
      reference
          .child("Requests")
          .child(currentUser.uid.toString())
          .remove()
          .whenComplete(() async {
        DatabaseReference reference1 =
            await FirebaseDatabase.instance.reference();
        Map<String, dynamic> data1 = {"request_type": "not_requested"};
        reference1
            .child("Rooms")
            .child(_roomsList[index1].room_id)
            .update(data1)
            .whenComplete(() {
          _request = "BOOK NOW";
          _requestType = "not_requested";
          _color = Colors.green;
          _isLoading = false;
              setState(() {
          });
        });
      });
    }
    if (_requestType == "accepted") {
      DatabaseReference reference = await FirebaseDatabase.instance.reference();
      DatabaseReference reference2 = await FirebaseDatabase.instance.reference();
      DatabaseReference reference3 = await FirebaseDatabase.instance.reference();
      reference
          .child("Requests")
          .child(currentUser.uid.toString())
          .remove()
          .whenComplete(() async {
        DatabaseReference reference1 =
        await FirebaseDatabase.instance.reference();
        Map<String, dynamic> data1 = {"request_type": "not_requested"};
        reference1
            .child("Rooms")
            .child(_roomsList[index1].room_id)
            .update(data1)
            .whenComplete(() {
              reference2.child("Booked").child(currentUser.uid.toString()).remove().whenComplete((){
                reference3.child("Booked").child(widget.data[index1].provider_id).remove().whenComplete((){
                  _request = "BOOK NOW";
                  _requestType = "not_requested";
                  _color = Colors.green;
                  _isLoading = false;
                  setState(() {
                  });
                });
              });
        });
      });
    }
  }

  void modalBottomSheetMenu(int index) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Container(
                        padding: const EdgeInsets.only(top: 54),
                        decoration: BoxDecoration(
                            color: widget.state.themeData.primaryColor,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(16.0),
                                topRight: const Radius.circular(16.0))),
                        child: Center(
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      widget.data[widget.index].hostel_name,
                                      style: widget
                                          .state.themeData.textTheme.headline,
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Floor Number " +
                                          _roomsList[index].floor_num,
                                      style: widget
                                          .state.themeData.textTheme.caption,
                                    ),
                                    SizedBox(height: 15.0),
                                    Text(
                                      "Room Number " +
                                          _roomsList[index].room_num,
                                      style: widget
                                          .state.themeData.textTheme.caption,
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Room Rent " +
                                          "PKR " +
                                          widget.data[widget.index]
                                              .price_per_head,
                                      style: widget
                                          .state.themeData.textTheme.caption,
                                    ),
                                    SizedBox(height: 20.0),
                                    _isLoading
                                        ? CircularProgressIndicator()
                                        : FlatButton(
                                            splashColor: widget
                                                .state.themeData.splashColor,
                                            onPressed: () {
                                              setState(() {
                                                bookNowRoom(index);
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                _request,
                                                style: TextStyle(
                                                    color: _color,
                                                    fontSize: 30.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Container(
                          decoration: BoxDecoration(
                              color: widget.state.themeData.primaryColor,
                              border: Border.all(
                                  color: widget.state.themeData.accentColor,
                                  width: 3),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _roomsList[index].room_pic == null
                                      ? AssetImage('assets/na.jpg')
                                      : NetworkImage(
                                          _roomsList[index].room_pic)),
                              shape: BoxShape.circle),
                        ),
                      ))
                ],
              ),
            );
          });
        });
  }
}
