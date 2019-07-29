import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/model/hostel.dart';
import 'package:hostel_app/model/rooms.dart';
import 'package:hostel_app/pages/hostel_detail_page.dart';
import 'package:hostel_app/pages/user_hostel_detail_page.dart';

class DiscoverHostels extends StatefulWidget {
  final ChangeThemeState state;
  DiscoverHostels(this.state);
  @override
  _DiscoverHostelsState createState() => _DiscoverHostelsState();
}

class _DiscoverHostelsState extends State<DiscoverHostels> {
  List<Hostels> _hostelList = [];

  @override
  void initState() {
    super.initState();
    fetchHostels();
  }

  Future fetchHostels() async {
    DatabaseReference reference =
        await FirebaseDatabase.instance.reference().child("Hostels");
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
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Discover Rooms',
                  style: widget.state.themeData.textTheme.headline),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: _hostelList.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Swiper(
                  physics: BouncingScrollPhysics(),
                  autoplay: true,
                  viewportFraction: 0.7,
                  scale: 0.9,
                  scrollDirection: Axis.horizontal,
                  itemCount: _hostelList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserHostelDetailPage(
                                        data: _hostelList,
                                        index: index,
                                      )));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: 200.0,
                            color: widget.state.themeData.splashColor,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child:
//                                    Hero(
//                                      tag: _hostelList[index].hostel_pic,
//                                      child:
                                        _hostelList[index].hostel_pic == null
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
//                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 10.0),
                                    child: Text(_hostelList[index].hostel_name,
                                        style: widget
                                            .state.themeData.textTheme.caption,
                                        textAlign: TextAlign.center),
                                  ),
                                )
                              ],
                            ),
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
}
