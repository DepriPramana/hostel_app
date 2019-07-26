import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
//import 'package:image_picker/image_picker.dart';

import 'home_page.dart';
import 'login_page.dart';

class EditPage extends StatefulWidget {

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = new GlobalKey<FormState>();
  String _name;
  String _surname;
  String _phoneno;
  File _image;
  bool _isLoading;

  initState(){
    super.initState();
    _isLoading = false;
  }

  _signOut() async {
    try {
      FirebaseAuth mAuth = FirebaseAuth.instance;
      mAuth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (BuildContext context) => LoginSignUpPage()),
              (Route<dynamic> route) => false);
    } catch (e) {
      print(e);
    }
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
      DatabaseReference reference = await FirebaseDatabase.instance.reference();
      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      StorageReference ref = await
      FirebaseStorage.instance.ref().child("Profile_images").child(currentUser.uid + ".jpg");
      StorageUploadTask uploadTask = ref.putFile(_image);
      String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      Map data = {
        "email": currentUser.email.toString(),
        "first_name": _name,
        "last_name": _surname,
        "phone_no": _phoneno,
        "profile_pic": downloadUrl.toString()
      };
      reference.child("Users").child(currentUser.uid).set(data).whenComplete(() => "Uploaded");
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.clear();
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (BuildContext context) => HomePage()),
              (Route<dynamic> route) => false);
    }
    else {
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
                iconTheme: state.themeData.accentIconTheme,
                title: Text('Edit Profile',
                    style: state.themeData.textTheme.body1),
                actions: <Widget>[
                  IconButton(
                    onPressed: _validateAndSubmit,
                    icon: Icon(Icons.done),
                    color: state.themeData.accentColor,
                  ),
                  FlatButton(
                    onPressed: _signOut,
                    child: Text("Logout", style: state.themeData.textTheme.caption),
                  ),
                ],
              ),
              body: Form(
                key: _formKey,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    profileAvatar(state),
                    firstName(state),
                    surName(state),
                    phoneNumber(state),
                    _showCircularProgress()
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 20.0),
        child: CircularProgressIndicator(),
        alignment: Alignment.bottomCenter,
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Container phoneNumber(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Phone Number", style: state.themeData.textTheme.body2),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              color: state.themeData.primaryColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new TextFormField(
                style: state.themeData.textTheme.caption,
                decoration: InputDecoration(border: InputBorder.none),
                maxLines: 1,
                keyboardType: TextInputType.phone,
                autofocus: false,
                validator: (value) =>
                    value.isEmpty ? 'phone no can\'t be empty' : null,
                onSaved: (value) => _phoneno = value.trim(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container surName(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Sur name", style: state.themeData.textTheme.body2),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              color: state.themeData.primaryColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new TextFormField(
                style: state.themeData.textTheme.caption,
                decoration: InputDecoration(border: InputBorder.none),
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                validator: (value) =>
                    value.isEmpty ? 'Sur name can\'t be empty' : null,
                onSaved: (value) => _surname = value.trim(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container firstName(ChangeThemeState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("First name", style: state.themeData.textTheme.body2),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              color: state.themeData.primaryColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new TextFormField(
                style: state.themeData.textTheme.caption,
                decoration: InputDecoration(border: InputBorder.none),
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                validator: (value) =>
                    value.isEmpty ? 'First name can\'t be empty' : null,
                onSaved: (value) => _name = value.trim(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Container profileAvatar(ChangeThemeState state) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 30.0),
      child: InkWell(
        onTap: getImage,
        child: _image == null ? CircleAvatar(
          backgroundColor: state.themeData.primaryColor,
          foregroundColor: state.themeData.primaryColor,
          radius: 70.0,
          child: Icon(Icons.add_a_photo, color: state.themeData.accentColor, size: 30.0),
        ): CircleAvatar(
          backgroundColor: state.themeData.primaryColor,
          foregroundColor: state.themeData.primaryColor,
          radius: 70.0,
          backgroundImage: FileImage(_image),
        ),
      ),
    );
  }
}
