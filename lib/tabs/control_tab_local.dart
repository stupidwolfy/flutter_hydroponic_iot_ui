import 'package:flutter/material.dart';

class ControlTab extends StatefulWidget {
  const ControlTab({Key? key}) : super(key: key);

  @override
  _ControlTabState createState() => _ControlTabState();
}

class _ControlTabState extends State<ControlTab> {
  List<Widget> gridItem = [
    const CardItem(name: "test"),
    const CardItem(name: "Item"),
    const CardItem(name: "test"),
    const CardItem(name: "Item"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        padding: const EdgeInsets.all(15),
        children: gridItem,
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
