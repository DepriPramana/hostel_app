import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/model/request.dart';

class RequestPage extends StatefulWidget {

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {

  List<Requests> requestList = [];
  bool _isLoading = false;
  bool _isLoading2 = false;

  Future getRequestData() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    Query reference = await FirebaseDatabase.instance.reference().child("Requests");
    reference.orderByChild("provider_id").equalTo(currentUser.uid.toString()).once().then((DataSnapshot snapshot){
      if(snapshot.value != null) {
        var keys = snapshot.value.keys;
        var data = snapshot.value;
        requestList.clear();
        for (var singleKey in keys) {
          Requests hostels = new Requests(
            data[singleKey]["hostel_id"],
            data[singleKey]["provider_id"],
            data[singleKey]["request_type"],
            data[singleKey]["room_id"],
            data[singleKey]["user_id"],
            data[singleKey]["room_number"],
            data[singleKey]["hostel_name"],
            data[singleKey]["room_price"],
            data[singleKey]["user_name"],
            data[singleKey]["user_pic"],
          );
          reference.keepSynced(true);
          requestList.add(hostels);
        }
        setState(() {

        });
      }
      else {
        setState(() {

        });
      }
    });
  }

  Future cancelRequest(int index) async {
    setState(() {
      _isLoading2 = true;
    });
    DatabaseReference reference = await FirebaseDatabase.instance.reference();
    DatabaseReference reference3 = await FirebaseDatabase.instance.reference();
    reference
        .child("Requests")
        .child(requestList[index].user_id)
        .remove()
        .whenComplete((){
      Map<String, dynamic> data1 = {"request_type": "not_requested"};
      reference3
          .child("Rooms")
          .child(requestList[index].room_id)
          .update(data1)
          .whenComplete(() {
        getRequestData();
        _isLoading2 = false;
        setState(() {
        });
      });
    });
  }

  Future confirmRequest(int index) async {
    setState(() {
      _isLoading = true;
    });
    DatabaseReference reference = await FirebaseDatabase.instance.reference();
    DatabaseReference reference1 = await FirebaseDatabase.instance.reference();
    DatabaseReference reference2 = await FirebaseDatabase.instance.reference();
    DatabaseReference reference3 = await FirebaseDatabase.instance.reference();
    Map<String, dynamic> data = {
      "hostel_id": requestList[index].hostel_id,
      "provider_id": requestList[index].provider_id,
      "room_id": requestList[index].room_id,
      "user_id": requestList[index].user_id,
      "request_type": "accepted",
      "room_number": requestList[index].room_number,
      "hostel_name": requestList[index].hostel_name,
      "room_price": requestList[index].room_price,
      "user_name": requestList[index].user_name,
      "user_pic": requestList[index].user_pic
    };
    reference.child("Booked").child(requestList[index].provider_id).set(data).whenComplete((){
      reference1.child("Booked").child(requestList[index].user_id).set(data).whenComplete((){
        reference2.child("Requests").child(requestList[index].user_id).remove().whenComplete((){
          Map<String, dynamic> data1 = {"request_type": "accepted"};
          reference3
              .child("Rooms")
              .child(requestList[index].room_id)
              .update(data1)
              .whenComplete(() {
            getRequestData();
            _isLoading = false;
            setState(() {

            });
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return requestList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: requestList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 170,
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
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
                                        left: 115.0, top: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            requestList[index].hostel_name,
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
                                                requestList[index]
                                                    .user_name,
                                                style: state.themeData
                                                    .textTheme.caption,
                                              ),
                                              SizedBox(width: 10.0, height: 5.0),
                                              Text(
                                                "Room No " + requestList[index].room_number + " PKR " +
                                                    requestList[index]
                                                        .room_price,
                                                style: state.themeData.textTheme
                                                    .caption,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: _isLoading2 ? Container(width: 30.0, height: 30.0 ,child: CircularProgressIndicator()) : FlatButton(
                                                  onPressed: () {
                                                    cancelRequest(index);
                                                  },
                                                  child: Text("CANCEL", style: state.themeData.textTheme.caption),
                                                  color: Colors.red[300],
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                                ),
                                              ),
                                              Container(
                                                child: _isLoading ? Container(width: 30.0, height: 30.0 ,child: CircularProgressIndicator()) : FlatButton(
                                                  onPressed: () {
                                                    confirmRequest(index);
                                                  },
                                                  child: Text("CONFIRM", style: state.themeData.textTheme.caption),
                                                  color: Colors.green,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                                ),
                                              )
                                            ],
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
                                          requestList[index].user_pic),
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
                    );
                  },
                );
        });
  }
}
