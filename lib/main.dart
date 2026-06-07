import 'package:flutter/material.dart';
import 'package:pertemuan10_2306041/pages/home_page.dart';
import 'package:pertemuan10_2306041/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool('isLogin') ?? false;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin ? const HomePage() : const LoginPage(),
    );
  }
}
