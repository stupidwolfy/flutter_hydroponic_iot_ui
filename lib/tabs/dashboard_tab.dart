import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
      color: Colors.white,
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
  String? deviceAddress;
  int? devicePort;
  bool? autoUpdate;
  int? autoUpdateTime;

  late Future<Device> futureDevice;

  _fetchAllDevice() async {
    deviceAddress ?? await _loadSetting();
    futureDevice = fetchDevice(deviceAddress, devicePort, "sensor/temp");
  }

  _loadSetting() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'SharedPreferences'. If got null, return desired default value.
    setState(() {
      deviceAddress = prefs.getString('device-address') ?? "192.168.1.2";
      devicePort = prefs.getInt('device-port') ?? 5000;
      autoUpdate = prefs.getBool('auto-update') ?? false;
      autoUpdateTime = prefs.getInt('auto-update-time') ?? 5;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAllDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder<Device>(
        future: futureDevice,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Text(widget.deviceName),
                const SizedBox(height: 10),
                Text('Temp: ' + snapshot.data!.temperature.toString()),
                const SizedBox(height: 5),
                Text('Humid: ' + snapshot.data!.humid.toString()),
                const SizedBox(height: 5),
              ],
            );
          } else if (snapshot.hasError) {
            return Column(children: [
              Text(widget.deviceName),
              const Text("error"),
              Text('${snapshot.error}')
            ]);
          }

          // By default, show a loading spinner.
          return Container(
              padding: const EdgeInsets.all(30),
              child: const CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
              ));
        },
      ),
      color: Colors.green,
    );
  }
}

//Network handle
Future<Device> fetchDevice(address, port, path) async {
  final response = await http.get(Uri.parse('http://$address:$port/$path'));

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
