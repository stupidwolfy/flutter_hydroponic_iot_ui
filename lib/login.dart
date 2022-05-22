// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool usingLocal;

  void signInLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("usingLocal", true);
    Navigator.popAndPushNamed(context, '/home');
  }

  Future<void> signInWithGoogle(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("usingLocal", false);

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.popAndPushNamed(context, '/home');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 500;
    return Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Flex(
                direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(flex: 10),
                  SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => signInWithGoogle(context),
                        child: Row(children: [
                          Spacer(flex: 10),
                          FaIcon(
                            FontAwesomeIcons.google,
                            size: 30,
                          ),
                          Spacer(flex: 5),
                          Text("Sign in with Google",
                              style: Theme.of(context).textTheme.headline6),
                          Spacer(flex: 10)
                        ]),
                      )),
                  // const Spacer(flex: 1),
                  // const Text("or"),
                  // const Spacer(flex: 1),
                  // TextButton(
                  //     onPressed: () => signInLocal(),
                  //     child: const Text("Local Mode")),
                  const Spacer(flex: 10),
                ],
              ),
            )));
  }
}
