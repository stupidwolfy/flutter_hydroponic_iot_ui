import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class DashBoardTab extends StatefulWidget {
  const DashBoardTab({Key? key}) : super(key: key);

  @override
  _DashBoardTabState createState() => _DashBoardTabState();
}

class _DashBoardTabState extends State<DashBoardTab> {
  String deviceAddress = "";
  int devicePort = 0;
  bool autoUpdate = false;
  int autoUpdateTime = 5;

  _loadSetting() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'SharedPreferences'. If got null, return desired default value.
    setState(() {
      deviceAddress = prefs.getString('device-address') ?? "localhost";
      devicePort = prefs.getInt('device-port') ?? 5000;
      autoUpdate = prefs.getBool('auto-update') ?? false;
      autoUpdateTime = prefs.getInt('auto-update-time') ?? 5;
    });
  }

  late List<Widget> deviceCardList = [
    DeviceCard(
      icon: Icons.air,
      name: "Air",
      path: "sensor/temp",
      address: deviceAddress,
      port: devicePort,
      autoUpdate: autoUpdate,
      autoUpdateTime: autoUpdateTime,
      dataList: const ["temp", "humid"],
      dataSuffixList: const ["°C", "%"],
    ),
    DeviceCard(
      icon: Icons.water,
      name: "Water",
      path: "sensor/water_temp",
      address: deviceAddress,
      port: devicePort,
      autoUpdate: autoUpdate,
      autoUpdateTime: autoUpdateTime,
      dataList: const ["temp"],
      dataSuffixList: const ["°C"],
    ),
    DeviceCard(
      icon: Icons.opacity,
      name: "PH",
      path: "sensor/ph",
      address: deviceAddress,
      port: devicePort,
      autoUpdate: autoUpdate,
      autoUpdateTime: autoUpdateTime,
      dataList: const ["ph"],
      dataSuffixList: const [""],
    ),
    DeviceCard(
      icon: Icons.local_drink,
      name: "EC",
      path: "sensor/ec",
      address: deviceAddress,
      port: devicePort,
      autoUpdate: autoUpdate,
      autoUpdateTime: autoUpdateTime,
      dataList: const ["ec"],
      dataSuffixList: const ["dS/m"],
    ),
    DeviceCard(
      icon: Icons.ac_unit,
      name: "Camera",
      path: "",
      address: deviceAddress,
      port: devicePort,
      autoUpdate: autoUpdate,
      autoUpdateTime: autoUpdateTime,
      dataList: const [],
      dataSuffixList: const [],
      image: Image.network(
        "http://$deviceAddress:$devicePort/cam",
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Icon(
            Icons.image_not_supported_outlined,
            size: 50,
          );
        },
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (deviceAddress.isEmpty) {
        return const CircularProgressIndicator.adaptive();
      } else {
        return Container(
          color: Colors.white,
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            padding: const EdgeInsets.all(15),
            children: deviceCardList,
          ),
        );
      }
    });
  }
}

class DeviceCard extends StatefulWidget {
  final IconData icon;
  final String name;
  final String path;

  final String address;
  final int port;
  final bool autoUpdate;
  final int autoUpdateTime;

  final List<String> dataList;
  final List<String> dataSuffixList;
  final Image? image;

  final String lastValue = "loading";

  const DeviceCard({
    Key? key,
    required this.name,
    required this.path,
    required this.address,
    required this.port,
    required this.autoUpdate,
    required this.autoUpdateTime,
    required this.dataList,
    required this.icon,
    required this.dataSuffixList,
    this.image,
  }) : super(key: key);

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late Future<Map<String, dynamic>> device;

  @override
  void initState() {
    super.initState();
    device = fetchDevice(widget.address, widget.port, widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder(
        future: device,
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (widget.image == null) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Icon(widget.icon, size: 50),
                  const SizedBox(height: 10),
                  Text(widget.name,
                      style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 10),
                  if (snapshot.data!['status'] == 'ok')
                    ...widget.dataList
                        .mapIndexed((index, i) => Column(
                              children: [
                                Text(
                                    '$i: ${snapshot.data![i].toString()}${widget.dataSuffixList[index]}',
                                    style:
                                        Theme.of(context).textTheme.labelLarge),
                                const SizedBox(height: 5),
                              ],
                            ))
                        .toList()
                  else
                    Text(snapshot.data!['detail'],
                        style: Theme.of(context).textTheme.headline6)
                ],
              );
            } else if (snapshot.hasError) {
              return Column(children: [
                Text(widget.name),
                const Text("error"),
                Text('${snapshot.error}')
              ]);
            }
          } else {
            return Column(children: [
              const SizedBox(height: 30),
              Center(child: widget.image),
              const SizedBox(height: 10),
              Text(widget.name, style: Theme.of(context).textTheme.headline6),
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
Future<Map<String, dynamic>> fetchDevice(address, port, path) async {
  late http.Response? response;
  try {
    response = await http.get(Uri.parse('http://$address:$port/$path'));
  } on SocketException catch (e) {
    response = null;
  }

  if (response == null) {
    return {"status": "Error", "detail": "Connection failed."};
  } else {
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Device.fromJson(jsonDecode(response.body));
      Map<String, dynamic> data = jsonDecode(response.body);
      data["status"] = "ok";
      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load device');
    }
  }
}
