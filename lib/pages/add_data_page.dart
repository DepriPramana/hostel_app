import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/pages/provider_page.dart';
import 'package:hostel_app/pages/settings_two.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class AddDataPage extends StatefulWidget {
  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  File _image;
  String _hostelName,
      _locationName,
      _pricePerHead,
      _contact,
      _numOfRooms,
      _userName,
      _generate = "",
      _internet = "",
      _meal = "",
      _laundry = "";
  bool _isGenerate = false,
      _isInternet = false,
      _isMeal = false,
      _isLaundry = false;
  final _formKey = new GlobalKey<FormState>();
  List<String> facilities;
  bool _isLoading = false;

  String _currentHostelId = "";

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
            child: _image == null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Icon(Icons.add_a_photo,
                        color: Colors.white70, size: 100.0))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image(
                      height: 200.0,
                      fit: BoxFit.cover,
                      image: FileImage(_image),
                    ))));
  }

  Container nameSection(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Hostel name", style: state.themeData.textTheme.body2),
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
                keyboardType: TextInputType.text,
                validator: (value) =>
                    value.isEmpty ? 'Name can\'t be empty' : null,
                onSaved: (value) => _hostelName = value.trim(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container locSection(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Location name", style: state.themeData.textTheme.body2),
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
                keyboardType: TextInputType.text,
                validator: (value) =>
                    value.isEmpty ? 'Location can\'t be empty' : null,
                onSaved: (value) => _locationName = value.trim(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container roomsSection(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("No. of Rooms", style: state.themeData.textTheme.body2),
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
                validator: (value) =>
                    value.isEmpty ? 'Room No can\'t be empty' : null,
                onSaved: (value) => _numOfRooms = value.trim(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container priceSection(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Price per head", style: state.themeData.textTheme.body2),
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
                maxLength: 4,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value.isEmpty ? 'Price can\'t be empty' : null,
                onSaved: (value) => _pricePerHead = value.trim(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container contactSection(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Contact Number", style: state.themeData.textTheme.body2),
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
                maxLength: 11,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value.isEmpty ? 'Contact can\'t be empty' : null,
                onSaved: (value) => _contact = value.trim(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Row generatorSection(ChangeThemeState state) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _isGenerate,
          onChanged: (bool val) {
            setState(() {
              _isGenerate = val;
            });
          },
        ),
        Text("Generator", style: state.themeData.textTheme.body2),
      ],
    );
  }

  Row internetSection(ChangeThemeState state) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _isInternet,
          onChanged: (bool val) {
            setState(() {
              _isInternet = val;
            });
          },
        ),
        Text("Internet", style: state.themeData.textTheme.body2),
      ],
    );
  }

  Row mealSection(ChangeThemeState state) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _isMeal,
          onChanged: (bool val) {
            setState(() {
              _isMeal = val;
            });
          },
        ),
        Text("Meal", style: state.themeData.textTheme.body2),
      ],
    );
  }

  Row laundrySection(ChangeThemeState state) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _isLaundry,
          onChanged: (bool val) {
            setState(() {
              _isLaundry = val;
            });
          },
        ),
        Text("Laundry", style: state.themeData.textTheme.body2),
      ],
    );
  }

  Container facilitySection(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Facilities", style: state.themeData.textTheme.body2),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              color: state.themeData.splashColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Wrap(
              spacing: 0.0, // gap between adjacent chips
              runSpacing: 0.0,
              children: <Widget>[
                generatorSection(state),
                internetSection(state),
                mealSection(state),
                laundrySection(state),
              ],
            ),
          )
        ],
      ),
    );
  }

  String getFacilities() {
    if (_isGenerate) {
      setState(() {
        _generate = "Generator";
      });
    }
    if (_isInternet) {
      setState(() {
        _internet = "Internet";
      });
    }
    if (_isMeal) {
      setState(() {
        _meal = "Meal";
      });
    }
    if (_isLaundry) {
      setState(() {
        _laundry = "Laundry";
      });
    }
    return _generate + " " + _internet + " " + _meal + " " + _laundry;
  }

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
      DatabaseReference userReference =
          await FirebaseDatabase.instance.reference();
      DatabaseReference reference = await FirebaseDatabase.instance.reference();
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      userReference
          .child("Users")
          .child(currentUser.uid.toString())
          .once()
          .then((DataSnapshot snapShot) {
        setState(() {
          _userName =
              snapShot.value["first_name"] + " " + snapShot.value["last_name"];
        });
      });
      StorageReference ref = await FirebaseStorage.instance
          .ref()
          .child("Hostel_images")
          .child(_image.uri.toString() + ".jpg");
      StorageUploadTask uploadTask = ref.putFile(_image);
      String downloadUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();
      Map data = {
        "hostel_name": _hostelName,
        "provider_name": _userName,
        "provider_id": currentUser.uid.toString(),
        "location_name": _locationName,
        "no_of_room": _numOfRooms,
        "price_per_head": _pricePerHead,
        "contact_number": _contact,
        "hostel_pic": downloadUrl,
        "hostel_facilities": getFacilities()
      };
      _currentHostelId = reference
          .child("Hostels")
          .push().key;
          reference.child("Hostels").child(_currentHostelId).set(data).whenComplete(()=> {

          });
          Map<String,dynamic> data1 = {
            "hostel_id": _currentHostelId
          };
      DatabaseReference reference2 = await FirebaseDatabase.instance.reference();
          reference2.child("Hostels").child(_currentHostelId).update(data1).whenComplete(()=> "");
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (BuildContext context) => ProviderPage()),
          (Route<dynamic> route) => false);
    } else {
      setState(() {
        _isLoading = false;
      });
      Toast.show("Something missing", context, duration: 5);
    }
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
                  Text("Room Sharing App", style: state.themeData.textTheme.headline),
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
                    nameSection(state),
                    locSection(state),
                    roomsSection(state),
                    priceSection(state),
                    contactSection(state),
                    facilitySection(state)
                  ],
                ),
              ),
            ),
            drawer: Drawer(child: SettingsPageTwo()),
          ),
        );
      },
    );
  }
}
