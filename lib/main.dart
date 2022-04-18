import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("initScreen", 12);
  final bool usingLocal = (prefs.getBool("usingLocal") ?? false);
  runApp(MyApp(usingLocal: usingLocal));
}

class MyApp extends StatelessWidget {
  final bool usingLocal;

  const MyApp({Key? key, required this.usingLocal}) : super(key: key);

  //Switch default start page
  String mainpageRedirect() {
    if (FirebaseAuth.instance.currentUser != null || usingLocal) return '/home';
    return '/login';
  }

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
      initialRoute: mainpageRedirect(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
