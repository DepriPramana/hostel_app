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

  @override
  void initState() {
    super.initState();
    _getRoomsData();
  }

  Future _getRoomsData() async {
    Query reference = await FirebaseDatabase.instance.reference().child("Rooms").orderByChild("hostel_id").equalTo(widget.data[widget.index].hostel_id);
    reference.once().then((DataSnapshot snapshot){
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      _roomsList.clear();
      for (var singleKey in keys) {
        Rooms rooms = new Rooms(
          data[singleKey]["floor_num"],
          data[singleKey]["hostel_id"],
          data[singleKey]["occupancy"],
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
              Text("Rooms",
                  style: widget.state.themeData.textTheme.headline),
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
                              child:
                              _roomsList[index].room_pic == null
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
                            style: widget.state.themeData.textTheme.caption,
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

  Future bookNowRoom() async {

  }

  void modalBottomSheetMenu(int index) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
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
                                    style: widget.state.themeData.textTheme.headline,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    "Floor Number " + _roomsList[index].floor_num,
                                    style: widget.state.themeData.textTheme.caption,
                                  ),
                                  SizedBox(height: 15.0),
                                  Text(
                                    "Room Number " + _roomsList[index].room_num,
                                    style: widget.state.themeData.textTheme.caption,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    "Room Rent " + "PKR " + widget.data[widget.index].price_per_head,
                                    style: widget.state.themeData.textTheme.caption,
                                  ),
                                  SizedBox(height: 20.0),
                                  FlatButton(
                                    splashColor: widget.state.themeData.splashColor,
                                    onPressed: bookNowRoom,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "BOOK NOW",
                                        style: TextStyle(color: Colors.green, fontSize: 30.0, fontWeight: FontWeight.bold),
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
                                color: widget.state.themeData.accentColor, width: 3),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _roomsList[index].room_pic == null
                                    ? AssetImage('assets/images/na.jpg')
                                    : NetworkImage(_roomsList[index].room_pic)),
                            shape: BoxShape.circle),
                      ),
                    ))
              ],
            ),
          );
        });
  }

}
