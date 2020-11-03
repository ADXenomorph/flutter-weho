import 'package:flutter/material.dart';
import 'package:weho/src/services/auth.service.dart';
import 'src/services/storage.service.dart';
import 'src/pages/loginPage.dart';
import 'src/pages/calendarPage.dart';

final baseUrl = 'http://dom.roowix.com';

void main() {
  runApp(WehoApp());
}

class WehoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weho',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/calendar': (context) => CalendarPage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StorageService().loadToken(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        return AuthService().isLoggedIn()
          ? CalendarPage()
          : LoginPage();
      }
    );
  }
}