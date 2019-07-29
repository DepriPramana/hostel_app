import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/bloc/change_theme_bloc.dart';
import 'package:hostel_app/bloc/change_theme_state.dart';
import 'package:hostel_app/pages/settings.dart';
import 'package:hostel_app/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_page.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  FormMode _formMode = FormMode.LOGIN;
  bool _isLoading;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    setState(() {
      _radioValue = "User";
    });
    super.initState();
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      String userId = "";
      try {
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password, _radioValue);
          sharedPreferences.setString("status", "yes");
          sharedPreferences.commit();
          print(sharedPreferences.getString("status"));
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(
                  builder: (BuildContext context) => EditPage(radioValue: _radioValue)),
              (Route<dynamic> route) => false);
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  int option;
  final List<Color> colors = [Colors.white, Color(0xff242248), Colors.black];
  final List<Color> borders = [Colors.black, Colors.white, Colors.white];
  final List<String> themes = ['Light', 'Amoled', 'Dark'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return SafeArea(
            child: new Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/login_background.jpg"),
                          fit: BoxFit.cover)),
                  child: Stack(
                    children: <Widget>[
                      _showBody(state),
                      _showCircularProgress()
                    ],
                  ),
                )),
          );
        }
    );
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

  Widget _showBody(ChangeThemeState state) {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              userChoice(context),
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(state),
              SizedBox(height: 10.0),
              _showSecondaryButton(),
              _showErrorMessage(),
              SettingsPage()
            ],
          ),
        ));
  }

  int _radioOption = 0;
  String _radioValue = "";

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioOption = value;
      switch (_radioOption) {
        case 0:
          _radioValue = "User";
          break;
        case 1:
          _radioValue = "Provider";
          break;
      }
    });
  }

  userChoice(BuildContext context) {
    return _formMode == FormMode.LOGIN
        ? Container(height: 0.0, width: 0.0)
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio(
                      activeColor: Colors.black,
                      value: 0,
                      groupValue: _radioOption,
                      onChanged: _handleRadioValueChange,
                    ),
                    Text("I am User"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      activeColor: Colors.black,
                      value: 1,
                      groupValue: _radioOption,
                      onChanged: _handleRadioValueChange,
                    ),
                    Text("I am Provider")
                  ],
                ),
              ],
            ),
          );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: FadeInImage(placeholder: AssetImage('assets/loading.gif'), image: AssetImage(
              "assets/logo.png"),
          fit: BoxFit.fill,
        ))
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Create an account',
              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : new Text('Have an account? Sign in',
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showPrimaryButton(ChangeThemeState state) {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: state.themeData.primaryColor,
            child: _formMode == FormMode.LOGIN
                ? new Text('Login',
                    style: state.themeData.textTheme.body2)
                : new Text('Create account',
                    style: state.themeData.textTheme.body2),
            onPressed: _validateAndSubmit,
          ),
        ));
  }
}
