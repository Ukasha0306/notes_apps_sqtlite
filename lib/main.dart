import 'package:flutter/material.dart';
import 'package:notes_apps_sqtlite/view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: const AppBarTheme(
            color: Colors.deepPurple,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 18)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
