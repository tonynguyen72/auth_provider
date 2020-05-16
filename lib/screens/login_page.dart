import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_provider/providers/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

enum AuthMode { LOGIN, SIGNUP }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //?
  var _formKey = GlobalKey<FormState>();
  String _password, _email;

  String _firstName, _lastName;

  AuthMode _authMode = AuthMode.LOGIN;
  //  final AuthServices _authServices = locator<AuthServices>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(radius: 80),
              SizedBox(height: 50),
              if (_authMode == AuthMode.SIGNUP)
                TextFormField(
                  onSaved: (value) => _firstName = value,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "First Name"),
                ),
              if (_authMode == AuthMode.SIGNUP)
                TextFormField(
                  onSaved: (value) => _lastName = value,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Last Name"),
                ),
              TextFormField(
                onSaved: (value) => _email = value,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email Address"),
              ),
              TextFormField(
                onSaved: (value) => _password = value,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: () async {
                    final form = _formKey.currentState;
                    form.save();
                    if (form.validate()) {
                      if (_authMode == AuthMode.LOGIN) {
                        try {
                          FirebaseUser result = await Provider.of<AuthService>(
                                  context,
                                  listen: false)
                              .loginUser(email: _email, password: _password);
                          print(result);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomePage(
                                    currentUser: result,
                                  )));
                        } on AuthException catch (error) {
                          return _buildShowErrorDialog(context, error.message);
                        } on Exception catch (error) {
                          return _buildShowErrorDialog(
                              context, error.toString());
                        }
                      } else {
                        try {
                          await Provider.of<AuthService>(context, listen: false)
                              .createUser(
                            firstName: _firstName,
                            lastName: _lastName,
                            email: _email,
                            password: _password,
                          );
                        } on AuthException catch (error) {
                          return _buildShowErrorDialog(context, error.message);
                        } on Exception catch (error) {
                          return _buildShowErrorDialog(
                              context, error.toString());
                        }
                      }
                    }
                  },
                  child: Text(_authMode == AuthMode.LOGIN ? 'LOGIN' : 'SIGNUP'),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _authMode == AuthMode.LOGIN
                        ? "Don't have an account ?"
                        : "Already have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _authMode != AuthMode.LOGIN
                            ? _authMode = AuthMode.LOGIN
                            : _authMode = AuthMode.SIGNUP;
                      });
                    },
                    textColor: Colors.black87,
                    child: Text(
                      _authMode != AuthMode.LOGIN ? "Login" : "Create Account",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  //?widget methods here
  Future _buildShowErrorDialog(BuildContext context, _message) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Error Message'),
              content: Text(_message),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            ));
  }
}
