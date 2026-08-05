import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scene Repros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF70887D),
          brightness: Brightness.dark,
        ),
      ),
      home: const ReproCatalogPage(),
    );
  }
}

class ReproCatalogPage extends StatelessWidget {
  const ReproCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Scene Repros')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: const [
          ListTile(
            title: Text('No case selected'),
            subtitle: Text('Check out a case/<id> branch or repro/<id>-fixed tag.'),
          ),
        ],
      ),
    );
  }
}
