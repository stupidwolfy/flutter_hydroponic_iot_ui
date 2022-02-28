import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DashBoardTab extends StatefulWidget {
  const DashBoardTab({Key? key}) : super(key: key);

  @override
  _DashBoardTabState createState() => _DashBoardTabState();
}

class _DashBoardTabState extends State<DashBoardTab> {
  List<Widget> gridItem = const [
    CardItem(deviceName: "Air sensor"),
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

class CardItem extends StatefulWidget {
  final String deviceName;
  final String lastValue = "loading";

  const CardItem({Key? key, required this.deviceName}) : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  late Future<Device> futureDevice;

  @override
  void initState() {
    super.initState();
    futureDevice = fetchDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder<Device>(
        future: futureDevice,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: [
              Text(widget.deviceName),
              SizedBox(height: 10),
              Text('Temp: ' + snapshot.data!.temperature.toString()),
              SizedBox(height: 5),
              Text('Humid: ' + snapshot.data!.humid.toString()),
              SizedBox(height: 5),
            ],);
          } else if (snapshot.hasError) {
            return Column(children: [
              Text(widget.deviceName),
              const Text("error"),
              Text('${snapshot.error}')
            ]);
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
      color: Colors.white,
    );
  }
}

//Network handle
Future<Device> fetchDevice() async {
  final response =
      await http.get(Uri.parse('http://192.168.43.96:5000/sensor/temp'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Device.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Device {
  final double temperature;
  final int humid;

  const Device({
    required this.temperature,
    required this.humid,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      temperature: json['temp'],
      humid: json['humid'],
    );
  }
}
