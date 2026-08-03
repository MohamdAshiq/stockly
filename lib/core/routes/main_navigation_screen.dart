import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/watchlist/presentation/pages/watchlist_page.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [HomePage(), WatchlistPage()];

  final List<String> _titles = const [
    AppStrings.homeTabTitle,
    AppStrings.watchlistTabTitle,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.homeTabTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: AppStrings.watchlistTabTitle,
          ),
        ],
      ),
    );
  }
}
