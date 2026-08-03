import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';

class AppRouter {
  static const String mainRoute = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainRoute:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
