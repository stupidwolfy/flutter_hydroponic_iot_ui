import 'package:flutter/material.dart';
import 'login.dart';
import 'home_cloud.dart';
import 'home_local.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        textTheme: const TextTheme(
            //headline2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/local': (context) => const LocalHomeScreen(),
        '/cloud': (context) => const CloudHomeScreen(),
      },
    );
  }
}
