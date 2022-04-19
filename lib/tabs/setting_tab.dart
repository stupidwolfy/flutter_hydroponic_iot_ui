import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingTab extends StatefulWidget {
  const SettingTab({Key? key}) : super(key: key);

  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  final _formKey = GlobalKey<FormState>();

  String? deviceAddress;
  int? devicePort;
  bool? autoUpdate;
  int? autoUpdateTime;
  bool usingLocal = false;

  final deviceAddressController = TextEditingController();

  void _toLoginPage() async {
    final prefs = await SharedPreferences.getInstance();
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }
    await prefs.setBool("usingLocal", false);

    Navigator.popAndPushNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    deviceAddressController.dispose();
    super.dispose();
  }

  void _loadSetting() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'SharedPreferences'. If got null, return desired default value.
    setState(() {
      deviceAddress = prefs.getString('device-address') ?? "192.168.1.2";
      devicePort = prefs.getInt('device-port') ?? 5000;
      autoUpdate = prefs.getBool('auto-update') ?? false;
      autoUpdateTime = prefs.getInt('auto-update-time') ?? 5;
      usingLocal = prefs.getBool("usingLocal") ?? false;

      deviceAddressController.text = deviceAddress ?? "";
    });
  }

  void _setAutoUpdate(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      autoUpdate = value;
    });
    prefs.setBool('auto-update', value);
  }

  void _saveDeviceAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      deviceAddress = deviceAddressController.text;
    });
    prefs.setString('device-address', deviceAddressController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: _setAutoUpdate,
                onPressed: (context) {
                  _setAutoUpdate(autoUpdate!);
                },
                initialValue: autoUpdate,
                leading: const Icon(Icons.update),
                title: const Text('Auto Update'),
                description: Text('update every $autoUpdateTime minute'),
              ),
            ],
          ),
          if (usingLocal)
            SettingsSection(title: const Text('Local'), tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.network_wifi),
                title: const Text('Device Address'),
                value: Text('$deviceAddress'),
                onPressed: (BuildContext context) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text("Device IP address"),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: deviceAddressController,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ElevatedButton(
                                        child: const Text("Save"),
                                        onPressed: () {
                                          _saveDeviceAddress();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red),
                                        ),
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.account_tree),
                title: const Text('Device port'),
                value: Text('$devicePort'),
                onPressed: (BuildContext context) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          clipBehavior: Clip.none,
                          content: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text("Device port number"),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    initialValue: devicePort.toString(),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ElevatedButton(
                                        child: const Text("Save"),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red),
                                        ),
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
              SettingsTile(
                title: Text(usingLocal ? "Login" : "Logout"),
                value: ElevatedButton(
                  child: Text(usingLocal ? "Login" : "Logout"),
                  onPressed: () => _toLoginPage(),
                ),
              ),
            ]),
        ],
      ),
    );
  }
}
