import 'package:flutter/material.dart';
//import 'package:flutter_hydroponic_iot_ui/tabs/control_tab.dart';
import 'package:flutter_hydroponic_iot_ui/tabs/dashboard_tab_local.dart';
import 'package:flutter_hydroponic_iot_ui/tabs/setting_tab_local.dart';

class LocalHomeScreen extends StatefulWidget {
  const LocalHomeScreen({Key? key}) : super(key: key);

  @override
  _LocalHomeScreenState createState() => _LocalHomeScreenState();
}

class _LocalHomeScreenState extends State<LocalHomeScreen> {
  final String _appbarName = "Local";
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
      appBar: AppBar(title: Text(_appbarName)),
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
