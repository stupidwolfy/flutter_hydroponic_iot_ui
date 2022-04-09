import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _onLoginButtonPressed(BuildContext context) {
    //<todo> add firebase login logic
    Navigator.popAndPushNamed(context, '/cloud');
  }

  void _onRegisterButtonPressed(BuildContext context) {
    //<todo> add firebase register / login logic
    Navigator.popAndPushNamed(context, '/cloud');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Email'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Password'),
                    validator: (String? value) {
                      if (value == null || value.length < 6) {
                        return 'Minimum 6 position';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Spacer(flex: 5),
                      ElevatedButton(
                        onPressed: () => _onLoginButtonPressed(context),
                        child: const Text("Login"),
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => _onRegisterButtonPressed(context),
                        child: const Text("Register"),
                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                      ),
                      const Spacer(flex: 5),
                    ],
                  ),
                  const Divider(thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () =>
                              Navigator.popAndPushNamed(context, '/local'),
                          child: const Text("Local Mode")),
                    ],
                  )
                ],
              ),
            )));
  }
}
