import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _appbarName = ["Dashboard", "Control", "Setting"];
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  final Container _homeContainer = Container(color: Colors.blue);
  final Container _controlContainer = Container(color: Colors.red);
  final Container _settingContainer = Container(color: Colors.green);

  void _onBottonNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_appbarName[_selectedIndex])),
      body: Center(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _homeContainer,
            _controlContainer,
            _settingContainer,
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ballot),
            label: 'Control',
          ),
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
