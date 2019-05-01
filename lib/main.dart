import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String _username;
String _password;

// Return true if success, false if fail
Future<bool> fetchPost() async {
  final response = await http.post(
    '', //Removed due to sensitive nature
    headers: {
      HttpHeaders.authorizationHeader: basicAuthHeader(_username, _password)
    },
  );
  final responseJson = json.decode(response.body);

  if (response.statusCode == 200) {
    // Login Successful
    return true;
  } else if (response.statusCode == 401) {
    // Unauthorized
    return false;
  }
  //detail -> invalid username/password
  return false;
}

String basicAuthHeader(String user, String pass) {
  return "Basic " + base64Encode(utf8.encode('$user:$pass'));
}

void main() {
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  bool _passwordHidden = true;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final _globalKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  //ProgressDialog _progressDialog = ProgressDialog.getProgressDialog(ProgressDialogTitles.USER_LOG_IN);

  TextEditingController _emailController = new TextEditingController(text: "");
  TextEditingController _passwordController =
      new TextEditingController(text: "");

  void validateAndLogin() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomPadding: true,
      body: ListView(
        children: <Widget>[
          Container(
              constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height),
              decoration: BoxDecoration(
                // Box decoration takes a gradient
                gradient: LinearGradient(
                  // Where the linear gradient begins and ends
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.0, 0.7],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    Colors.teal[900],
                    Colors.teal[800],
                  ],
                ),
              ),
              padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: new EdgeInsets.symmetric(horizontal: 100.0),
                    child: Image.asset('assets/logo.png',
                        fit: BoxFit.scaleDown),
                  ),
                  Text(
                    'FLUTTER LOGIN UI',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 26),
                  ),
                  SizedBox(height: 20.0),
                  _loginFormContainer(),
                  SizedBox(height: 40.0),
                  Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.green,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {
                          _loginButtonAction();
                        },
                        child: Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.blueAccent,
                      color: Colors.blue,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: Text(
                            'LOGIN WITH FACEBOOK',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.only(top: 15.0, left: 10.0),
                        child: InkWell(
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.only(top: 15.0, right: 10.0),
                        child: InkWell(
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  // Form for two text fields : Email and Password
  Widget _loginFormContainer() {
    _loginFormKey.currentState?.validate();
    return Form(
        key: _loginFormKey,
        child: Column(children: [
          _emailContainer(),
          SizedBox(height: 20.0),
          _passwordContainer(),
        ]));
  }

  Widget _emailContainer() {
    return TextFormField(
      controller: _emailController,
      style: TextStyle(
          fontFamily: 'Montserrat', color: Colors.white, fontSize: 20),
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
      focusNode: _emailFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (term) {
        FocusScope.of(context).requestFocus(_passwordFocus);
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        labelText: 'E-MAIL ADDRESS',
        labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white70),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
      ),
    );
  }

  Widget _passwordContainer() {
    return TextFormField(
      controller: _passwordController,
      style: TextStyle(
          fontFamily: 'Montserrat', color: Colors.white, fontSize: 20),
      keyboardType: TextInputType.text,
      validator: _validatePassword,
      focusNode: _passwordFocus,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        _passwordFocus.unfocus();
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordHidden ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordHidden
                  ? _passwordHidden = false
                  : _passwordHidden = true;
            });
          },
        ),
        labelText: 'PASSWORD',
        labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white70),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
      ),
      obscureText: _passwordHidden,
    );
  }

  String _validateEmail(String value) {
    // Check if email is legit
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      _username = null;
      return 'Enter Valid E-mail';
    } else {
      _username = value;
      return null;
    }
  }

  // validate password
  String _validatePassword(String password) {
    // Since test password is 6 chars length, use that as bare min
    if (password.length < 6) {
      _password = null;
      return 'Password must be at least 6 characters';
    } else {
      _password = password;
      return null;
    }
  }

  void _loginButtonAction() async {
    if (_loginFormKey.currentState.validate())
      _loginFormKey.currentState.save();
    FocusScope.of(context).requestFocus(new FocusNode());

    if (_username != null && _password != null) {
      bool success = await fetchPost();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('[dd-MM-yyyy kk:mm:ss]').format(now);
      // Show results of login attempt via snackbar
      if (success) {
        _globalKey.currentState.showSnackBar(new SnackBar(
          content: new Text(formattedDate + " Successful Login!"),
        ));
      } else {
        _globalKey.currentState.showSnackBar(new SnackBar(
          content: new Text(
              formattedDate + " Failed Login. Please check your credentials."),
        ));
      }
    }
  }
}
