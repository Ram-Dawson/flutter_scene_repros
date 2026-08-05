import 'package:flutter/material.dart';

import 'cases/rapier_snapshot_membership/rapier_snapshot_membership_page.dart';

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
        children: [
          ListTile(
            title: const Text('Rapier Snapshot Membership'),
            subtitle: const Text('Manual state check'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const RapierSnapshotMembershipPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
