import 'package:firebase_auth_provider/screens/home_page.dart';
import 'package:firebase_auth_provider/screens/login_page.dart';
import 'package:firebase_auth_provider/screens/undefine_page.dart';
import 'package:firebase_auth_provider/utilities/router_constants.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomePageRoute:
      return MaterialPageRoute(builder: (context) => HomePage());
    case LoginPageRoute:
      return MaterialPageRoute(builder: (context) => LoginPage());
      break;
    default:
      return MaterialPageRoute(builder: (context) => UndefinePage());
  }
}
