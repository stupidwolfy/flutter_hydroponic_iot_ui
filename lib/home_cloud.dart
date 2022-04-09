import 'package:flutter/material.dart';
import 'package:flutter_hydroponic_iot_ui/tabs/dashboard_tab_cloud.dart';
import 'package:flutter_hydroponic_iot_ui/tabs/setting_tab_cloud.dart';

class CloudHomeScreen extends StatefulWidget {
  const CloudHomeScreen({Key? key}) : super(key: key);

  @override
  _CloudHomeScreenState createState() => _CloudHomeScreenState();
}

class _CloudHomeScreenState extends State<CloudHomeScreen> {
  final List<String> _appbarName = ["Dashboard", /*"Control",*/ "Setting"];
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onBottonNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cloud")),
      body: Center(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            DashBoardTab(),
            //ControlTab(),
            SettingTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Dashboard',
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.ballot),
            label: 'Control',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onBottonNavTapped,
      ),
    );
  }
}
