import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingTab extends StatefulWidget {
  const SettingTab({Key? key}) : super(key: key);

  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: false,
                leading: const Icon(Icons.update),
                title: const Text('Auto Update'),
                description: const Text('update every 5 minute'),
              ),
              SettingsTile(
                leading: const Icon(Icons.network_wifi),
                title: const Text('Device Address'),
                value: const Text('http://192.168.66.66:5000'),
                onPressed: (BuildContext context) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Positioned(
                                right: -40.0,
                                top: -40.0,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const CircleAvatar(
                                    child: Icon(Icons.close),
                                    backgroundColor: Colors.black,
                                  ),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        child: const Text("Submitß"),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
