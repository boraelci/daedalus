import 'package:flutter/material.dart';
import 'package:daedalus/pages/map_page.dart';
import 'package:daedalus/pages/settings_page.dart';
import 'package:daedalus/pages/search_page.dart';

void main() {
  runApp(MaterialApp(home: MainApp()));
}

class MainApp extends StatefulWidget {

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late List<Widget> originalList;
  late Map<int, bool> originalDic;
  late List<Widget> listScreens;
  late List<int> listScreensIndex;

  int tabIndex = 0;
  Color tabColor = Colors.grey;
  Color selectedTabColor = Colors.black;

  @override
  void initState() {
    super.initState();

    originalList = [
      SearchPage(),
      MapPage(),
      const SettingsPage(),
    ];
    originalDic = {0: true, 1: false, 2: false};
    listScreens = [originalList.first];
    listScreensIndex = [0];

    _selectedTab(1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: IndexedStack(index:listScreensIndex.indexOf(tabIndex), children: listScreens),
        bottomNavigationBar: _buildTabBar(),
      ),
    );
  }

  void _selectedTab(int index) {
    if (originalDic[index] == false) {
      listScreensIndex.add(index);
      originalDic[index] = true;
      listScreensIndex.sort();
      listScreens = listScreensIndex.map((index) {
        return originalList[index];
      }).toList();
    }

    setState(() {
      tabIndex = index;
    });
  }

  Widget _buildTabBar() {
    var listItems = [
      BottomAppBarItem(iconData: Icons.search_rounded, text: ''),
      BottomAppBarItem(iconData: Icons.map_rounded, text: ''),
      BottomAppBarItem(iconData: Icons.person_rounded, text: ''),
    ];

    var items = List.generate(listItems.length, (int index) {
      return _buildTabItem(
        item: listItems[index],
        index: index,
        onPressed: _selectedTab,
      );
    });

    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildTabItem({
    required BottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    var color = tabIndex == index ? selectedTabColor : tabColor;
    return Expanded(
      child: SizedBox(
        height: 50,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Icon(item.iconData, color: color, size: 24),
          ),
        ),
      ),
    );
  }
}

class BottomAppBarItem {
  BottomAppBarItem({required this.iconData, required this.text});
  IconData iconData;
  String text;
}