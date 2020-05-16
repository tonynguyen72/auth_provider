import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_provider/locator.dart';
import 'package:firebase_auth_provider/providers/auth_service.dart';
import 'package:firebase_auth_provider/screens/home_page.dart';
import 'package:firebase_auth_provider/screens/login_page.dart';
import 'package:firebase_auth_provider/services/navigation_services.dart';
import 'package:firebase_auth_provider/services/router_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MyApp(),
    ),
    // MyApp()
  );
}

class MyApp extends StatelessWidget {
  // final AuthServices _authServices = locator<AuthServices>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorKey: locator<NavigationServices>().navigationKey,
      onGenerateRoute: generateRoute,
      home: FutureBuilder(
        future: Provider.of<AuthService>(context, listen: false).getUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.error != null) {
              print('initial error');
              return Text(snapshot.error.toString());
            }
            return snapshot.hasData
                ? HomePage(currentUser: snapshot.data)
                : LoginPage();
          } else {
            return Center(
                child: Container(
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }
}
