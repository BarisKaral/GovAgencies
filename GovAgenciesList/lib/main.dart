import 'package:flutter/material.dart';
import 'package:kurumlar/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Colors.black54),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: HomePage(),
      )
    );
  }
}
