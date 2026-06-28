import 'package:flutter/material.dart';

class POSApp extends StatelessWidget {
  const POSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drift POS',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: SizedBox.expand(),
      ),
    );
  }
}
