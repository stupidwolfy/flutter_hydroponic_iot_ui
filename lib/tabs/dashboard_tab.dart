import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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

  late List<ResponsiveGridCol> deviceCardList = [
    ResponsiveGridCol(
        md: 3,
        sm: 3,
        xs: 6,
        child: DeviceCard(
          icon: Icons.air,
          name: "Air Temp",
          path: "sensor/temp",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["temp", "humid"],
          dataSuffixList: const ["°C", "%"],
          firebaseDBDataName: "temp",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        md: 3,
        sm: 3,
        xs: 6,
        child: DeviceCard(
          icon: Icons.air,
          name: "Air Humid",
          path: "sensor/temp",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["temp", "humid"],
          dataSuffixList: const ["°C", "%"],
          firebaseDBDataName: "humid",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        md: 3,
        sm: 3,
        xs: 6,
        child: DeviceCard(
          icon: Icons.water,
          name: "Water",
          path: "sensor/water_temp",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["temp"],
          dataSuffixList: const ["°C"],
          firebaseDBDataName: "water-temp",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        md: 3,
        sm: 3,
        xs: 6,
        child: DeviceCard(
          icon: Icons.opacity,
          name: "PH",
          path: "sensor/ph",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["ph"],
          dataSuffixList: const [""],
          firebaseDBPath: 'device',
          firebaseDBDataName: "ph",
        )),
    ResponsiveGridCol(
        md: 3,
        sm: 3,
        xs: 6,
        child: DeviceCard(
          icon: Icons.local_drink,
          name: "EC",
          path: "sensor/ec",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["ec"],
          dataSuffixList: const ["dS/m"],
          firebaseDBDataName: "tds",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        md: 2,
        sm: 2,
        xs: 3,
        child: DeviceCard(
          icon: Icons.local_drink,
          name: "Relay0",
          path: "relay/0",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["relay"],
          dataSuffixList: const [""],
          firebaseDBDataName: "relay-0",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        md: 2,
        sm: 2,
        xs: 3,
        child: DeviceCard(
          icon: Icons.local_drink,
          name: "Relay1",
          path: "relay/1",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["relay"],
          dataSuffixList: const [""],
          firebaseDBDataName: "relay-1",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        md: 2,
        sm: 2,
        xs: 3,
        child: DeviceCard(
          icon: Icons.local_drink,
          name: "Relay2",
          path: "relay/2",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["relay"],
          dataSuffixList: const [""],
          firebaseDBDataName: "relay-2",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        md: 2,
        sm: 2,
        xs: 3,
        child: DeviceCard(
          icon: Icons.local_drink,
          name: "Relay3",
          path: "relay/3",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["relay"],
          dataSuffixList: const [""],
          firebaseDBDataName: "relay-3",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        md: 2,
        sm: 2,
        xs: 3,
        child: DeviceCard(
          icon: Icons.local_drink,
          name: "Relay4",
          path: "relay/4",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["relay"],
          dataSuffixList: const [""],
          firebaseDBDataName: "relay-4",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        md: 2,
        sm: 2,
        xs: 3,
        child: DeviceCard(
          icon: Icons.local_drink,
          name: "Relay5",
          path: "relay/5",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["relay"],
          dataSuffixList: const [""],
          firebaseDBDataName: "relay-5",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        md: 2,
        sm: 2,
        xs: 3,
        child: DeviceCard(
          icon: Icons.local_drink,
          name: "Relay6",
          path: "relay/6",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["relay"],
          dataSuffixList: const [""],
          firebaseDBDataName: "relay-6",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        md: 2,
        sm: 2,
        xs: 3,
        child: DeviceCard(
          icon: Icons.local_drink,
          name: "Relay7",
          path: "relay/7",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const ["relay"],
          dataSuffixList: const [""],
          firebaseDBDataName: "relay-7",
          firebaseDBPath: 'device',
        )),
    ResponsiveGridCol(
        xl: 6,
        lg: 6,
        md: 12,
        xs: 12,
        child: DeviceCard(
          icon: Icons.camera,
          name: "Camera",
          path: "",
          address: deviceAddress,
          port: devicePort,
          autoUpdate: autoUpdate,
          autoUpdateTime: autoUpdateTime,
          dataList: const [],
          dataSuffixList: const [],
          imagePath: "/cam",
          firebaseDBPath: 'device',
          firebaseDBDataName: "",
        )),
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
        return SingleChildScrollView(
          //color: Colors.white,
          child: ResponsiveGridRow(
            // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            // crossAxisCount: 2,
            // ),
            //padding: const EdgeInsets.all(15),
            children: deviceCardList,
          ),
        );
      }
    });
  }
}

class DeviceCard extends StatefulWidget {
  static FirebaseDatabase database = FirebaseDatabase.instance;

  final IconData icon;
  final String name;
  final String path;
  final String firebaseDBPath;

  final String address;
  final int port;
  final bool autoUpdate;
  final int autoUpdateTime;

  final List<String> dataList;
  final List<String> dataSuffixList;

  final String? imagePath;
  final String firebaseDBDataName;
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
    this.imagePath,
    required this.firebaseDBPath,
    required this.firebaseDBDataName,
  }) : super(key: key);

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late Future<Map<String, dynamic>> device;
  dynamic firebaseData = "";

  //Network handle
  Future<Map<String, dynamic>> fetchDevice(address, port, path) async {
    late http.Response? response;
    try {
      response = await http.get(Uri.parse('http://$address:$port/$path'));
    } on SocketException {
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

  void fetchFirebaseDeviceDB() {
    final DatabaseReference deviceDataRef = FirebaseDatabase.instance.ref(
        'users/${FirebaseAuth.instance.currentUser?.uid}/${widget.firebaseDBPath}');

    deviceDataRef.child(widget.firebaseDBDataName).onValue.listen((event) {
      dynamic dataValue = event.snapshot.value;
      setState(() {
        if (dataValue == null) {
          firebaseData = "??";
        } else if (dataValue.runtimeType == int && dataValue <= 1) {
          firebaseData = dataValue == 0 ? "OFF" : "ON";
        } else {
          firebaseData = dataValue;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      device = fetchDevice(widget.address, widget.port, widget.path);
    } else {
      fetchFirebaseDeviceDB();
    }
  }

  @override
  Widget build(BuildContext context) {
    //local dashboard
    if (FirebaseAuth.instance.currentUser == null) {
      return Card(
        child: FutureBuilder(
          future: device,
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (widget.imagePath == null) {
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge),
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
                Center(
                    child: Image.network(
                  "http://${widget.address}:${widget.port}/cam",
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Icon(
                      Icons.image_not_supported_outlined,
                      size: 50,
                    );
                  },
                  height: 100,
                )),
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
    } //cloud dashboard
    else {
      return Card(
        child: Column(
          children: [
            if (widget.imagePath == null) ...[
              const SizedBox(height: 10),
              Icon(widget.icon, size: 50),
              const SizedBox(height: 10),
              Text(widget.name),
              Text(firebaseData),
            ] else ...[
              const SizedBox(height: 30),
              Center(
                  child: Image.network(
                "http://${widget.address}:${widget.port}/{widget.imagePath}",
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    size: 50,
                  );
                },
                height: 100,
              )),
              const SizedBox(height: 10),
              Text(widget.name, style: Theme.of(context).textTheme.headline6),
            ]
          ],
        ),
        color: Colors.green,
      );
    }
  }
}
