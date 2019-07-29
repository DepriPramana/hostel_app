import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/model/hostel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import 'hostel_detail_page.dart';

class AddRoomPage extends StatefulWidget {

  String hostelId;
  AddRoomPage(this.hostelId);

  @override
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  bool _isLoading = false;
  File _image;
  final _formKey = new GlobalKey<FormState>();
  String _capacity = "", _roomNum = "", _floorNum = "";
  String _roomId = "";

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (_validateAndSave() && _image != null) {
      DatabaseReference reference = await FirebaseDatabase.instance.reference();
      StorageReference ref = await FirebaseStorage.instance
          .ref()
          .child("Room_images")
          .child(_image.uri.toString() + ".jpg");
      StorageUploadTask uploadTask = ref.putFile(_image);
      String downloadUrl =
      await (await uploadTask.onComplete).ref.getDownloadURL();
      _roomId = reference.child("Rooms").push().key;
      Map data = {
        "floor_num": _floorNum,
        "room_num": _roomNum,
        "occupancy": _capacity,
        "room_pic": downloadUrl,
        "hostel_id": widget.hostelId,
        "room_id": _roomId
      };
      reference.child("Rooms").child(_roomId).set(data).whenComplete(()=> "Uploaded");
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isLoading = false;
      });
      Toast.show("Something missing", context, duration: 5);
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  InkWell imageSection() {
    return InkWell(
        onTap: getImage,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            height: 300.0,
            child: _image == null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Icon(Icons.add_a_photo,
                        color: Colors.white70, size: 100.0))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(
                      fit: BoxFit.cover,
                      image: FileImage(_image),
                    ))));
  }

  Container roomCapacitySection(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Room Occupancy", style: state.themeData.textTheme.body2),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              color: state.themeData.splashColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new TextFormField(
                style: state.themeData.textTheme.body2,
                decoration: InputDecoration(border: InputBorder.none),
                maxLines: 1,
                maxLength: 2,
                keyboardType: TextInputType.number,
                autofocus: false,
                validator: (value) =>
                value.isEmpty ? 'Number can\'t be empty' : null,
                onSaved: (value) => _capacity = value.trim(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container roomNumSection(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Room Number", style: state.themeData.textTheme.body2),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              color: state.themeData.splashColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new TextFormField(
                style: state.themeData.textTheme.body2,
                decoration: InputDecoration(border: InputBorder.none),
                maxLines: 1,
                maxLength: 2,
                keyboardType: TextInputType.number,
                autofocus: false,
                validator: (value) =>
                value.isEmpty ? 'Room Number can\'t be empty' : null,
                onSaved: (value) => _roomNum = value.trim(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container roomFloorSection(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Room Floor", style: state.themeData.textTheme.body2),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              color: state.themeData.splashColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new TextFormField(
                style: state.themeData.textTheme.body2,
                decoration: InputDecoration(border: InputBorder.none),
                maxLines: 1,
                maxLength: 2,
                keyboardType: TextInputType.number,
                autofocus: false,
                validator: (value) =>
                value.isEmpty ? 'Floor Number can\'t be empty' : null,
                onSaved: (value) => _floorNum = value.trim(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: state.themeData.primaryColor,
                title:
                    Text("Add Room", style: state.themeData.textTheme.headline),
                actions: <Widget>[
                  _isLoading
                      ? Container(
                          margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          onPressed: _validateAndSubmit,
                          icon: Icon(Icons.done),
                          color: state.themeData.accentColor,
                        ),
                ],
              ),
              body: Form(
                key: _formKey,
                child: Container(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      imageSection(),
                      roomCapacitySection(state),
                      roomNumSection(state),
                      roomFloorSection(state),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
