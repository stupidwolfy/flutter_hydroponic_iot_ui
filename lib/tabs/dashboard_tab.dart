import 'package:flutter/material.dart';

class DashBoardTab extends StatefulWidget {
  const DashBoardTab({Key? key}) : super(key: key);

  @override
  _DashBoardTabState createState() => _DashBoardTabState();
}

class _DashBoardTabState extends State<DashBoardTab> {
  List<Widget> gridItem =const [
    CardItem(name: "test"),
    CardItem(name: "Item"),
    CardItem(name: "test"),
    CardItem(name: "Item"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
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
  const CardItem({Key? key,required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return  Card(
      child:  Column(children: [Text(name)]),
      color: Colors.white,
    );
  }
}
