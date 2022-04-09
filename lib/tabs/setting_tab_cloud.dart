import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final deviceAddressController = TextEditingController();

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
          SettingsSection(
              title: ElevatedButton(
                  onPressed: () => Navigator.popAndPushNamed(context, '/login'),
                  style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                  child: const Text("Logout")),
              tiles: const []),
        ],
      ),
    );
  }
}
