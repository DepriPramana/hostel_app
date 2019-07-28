import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/pages/settings_two.dart';
import 'package:image_picker/image_picker.dart';

class AddDataPage extends StatefulWidget {
  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {

  File _image;
  String _hostelName, _locationName, _pricePerHead, _contact, _numOfRooms;
  bool _isGenerate = false, _isInternet = false, _isMeal = false, _isLaundry = false;

  @override
  void initState() {
    super.initState();
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
          child: _image == null ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Icon(Icons.add_a_photo, color: Colors.white70, size: 100.0)
          ) : ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                height: 200.0,
                fit: BoxFit.cover,
                image: FileImage(_image),
              )
          )
      )
    );
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
              color: state.themeData.accentColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new TextFormField(
                style: state.themeData.textTheme.display1,
                decoration: InputDecoration(border: InputBorder.none),
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
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
              color: state.themeData.accentColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new TextFormField(
                style: state.themeData.textTheme.display1,
                decoration: InputDecoration(border: InputBorder.none),
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
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
              color: state.themeData.accentColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new TextFormField(
                style: state.themeData.textTheme.display1,
                decoration: InputDecoration(border: InputBorder.none),
                maxLines: 1,
                maxLength: 2,
                keyboardType: TextInputType.number,
                autofocus: false,
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
              color: state.themeData.accentColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new TextFormField(
                style: state.themeData.textTheme.display1,
                decoration: InputDecoration(border: InputBorder.none),
                maxLines: 1,
                maxLength: 4,
                keyboardType: TextInputType.number,
                autofocus: false,
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
              color: state.themeData.accentColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: new TextFormField(
                style: state.themeData.textTheme.display1,
                decoration: InputDecoration(border: InputBorder.none),
                maxLines: 1,
                maxLength: 11,
                keyboardType: TextInputType.phone,
                autofocus: false,
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
          onChanged: (bool val) =>
              setState(() => _isGenerate = val),
        ),
        Text("Generator", style: state.themeData.textTheme.caption),
      ],
    );
  }

  Row internetSection(ChangeThemeState state) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _isInternet,
          onChanged: (bool val) =>
              setState(() => _isInternet = val),
        ),
        Text("Internet", style: state.themeData.textTheme.caption),
      ],
    );
  }

  Row mealSection(ChangeThemeState state) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _isMeal,
          onChanged: (bool val) =>
              setState(() => _isMeal = val),
        ),
        Text("Meal", style: state.themeData.textTheme.caption),
      ],
    );
  }

  Row laundrySection(ChangeThemeState state) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _isLaundry,
          onChanged: (bool val) =>
              setState(() => _isLaundry = val),
        ),
        Text("Laundry", style: state.themeData.textTheme.caption),
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
              color: state.themeData.accentColor,
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
                  Text("Hostel App", style: state.themeData.textTheme.headline),
            ),
            body: Container(
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
            drawer: Drawer(child: SettingsPageTwo()),
          ),
        );
      },
    );
  }
}
