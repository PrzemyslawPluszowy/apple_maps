import 'package:apple_maps/core/constatns.dart';
import 'package:apple_maps/ui/map/map_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}
