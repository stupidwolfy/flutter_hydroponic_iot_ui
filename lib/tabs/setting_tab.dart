import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingTab extends StatefulWidget {
  const SettingTab({Key? key}) : super(key: key);

  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  List<Widget> columnItem = [
    CardItem(name: "test"),
    CardItem(name: "Item"),
    CardItem(name: "test"),
    CardItem(name: "Item"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(
        children: columnItem,
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [Text(name)]),
      color: Colors.white,
    );
  }
}
