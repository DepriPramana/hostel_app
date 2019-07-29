import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/model/hostel.dart';
import 'package:hostel_app/pages/hostel_detail_page.dart';
import 'package:hostel_app/pages/user_hostel_detail_page.dart';

class ByPriceRooms extends StatefulWidget {

  final ChangeThemeState state;

  ByPriceRooms(this.state);

  @override
  _ByPriceRoomsState createState() => _ByPriceRoomsState();
}

class _ByPriceRoomsState extends State<ByPriceRooms> {

  List<Hostels> _hostelList = [];

  @override
  void initState() {
    super.initState();
    fetchByPlaceHostels();
  }

  Future fetchByPlaceHostels() async {
    Query reference =
    await FirebaseDatabase.instance.reference().child("Hostels").orderByChild("price_per_head");
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
              child: Text("Rooms By Price",
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
              : ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _hostelList.length,
            scrollDirection: Axis.horizontal,
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
                  child:
//                  Hero(
//                    tag: _hostelList[index].hostel_pic,
//                    child:
                  SizedBox(
                    width: 100,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage(
                              image: NetworkImage(_hostelList[index].hostel_pic),
                              fit: BoxFit.cover,
                              placeholder: AssetImage(
                                  'assets/loading.gif'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "PKR " + _hostelList[index].price_per_head,
                            style: widget.state.themeData.textTheme.body2,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
//                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
