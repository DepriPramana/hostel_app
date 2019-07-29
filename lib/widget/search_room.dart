import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/model/hostel.dart';
import 'package:hostel_app/pages/user_hostel_detail_page.dart';

class SearchRoom extends StatefulWidget {
  final ThemeData themeData;
  final List<Hostels> hostelList;
  final String query;
  final Function(Hostels) onTap;

  SearchRoom({this.themeData, this.hostelList, this.query, this.onTap});
  @override
  _SearchRoomState createState() => _SearchRoomState();
}

class _SearchRoomState extends State<SearchRoom> {
  List<Hostels> _hostelList = [];

  @override
  void initState() {
    super.initState();
    fetchHostels();
  }

  Future fetchHostels() async {
    Query reference =
    await FirebaseDatabase.instance.reference().child("Hostels").orderByChild("hostel_name").startAt(widget.query).endAt(widget.query + "\uf8ff");
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
        reference.keepSynced(true);
        _hostelList.add(hostels);
      }
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData.primaryColor,
      child: _hostelList.length == 0
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _hostelList.length == 0
          ? Center(
        child: Text(
          "Oops! couldn't find the hostel or room",
          style: widget.themeData.textTheme.body2,
        ),
      )
          : ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _hostelList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserHostelDetailPage(data: _hostelList, index: index)));
              },
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 70,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: _hostelList[index].hostel_pic == null
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _hostelList[index].hostel_name,
                                style:
                                widget.themeData.textTheme.body1,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    _hostelList[index].location_name,
                                    style: widget
                                        .themeData.textTheme.body2,
                                  ),
                                  Icon(Icons.star,
                                      color: Colors.green)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Divider(
                      color: widget.themeData.accentColor,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}