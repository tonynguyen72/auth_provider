import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_provider/locator.dart';
import 'package:firebase_auth_provider/providers/auth_service.dart';
import 'package:firebase_auth_provider/services/navigation_services.dart';
import 'package:firebase_auth_provider/utilities/router_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  final FirebaseUser currentUser;
  HomePage({this.currentUser});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //?
  NavigationServices _navigationServices = locator<NavigationServices>();
  //  final AuthServices _authServices = locator<AuthServices>();
  //?
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              _navigationServices.navigateTo(LoginPageRoute, arguments: 'helo');
              await Provider.of<AuthService>
              (context, listen: false).logOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome ${widget.currentUser.displayName}"),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () => _navigationServices.navigateTo(LoginPageRoute, arguments: 'helo'),
            ),
          ],
        ),
      ),
    );
  }
}
