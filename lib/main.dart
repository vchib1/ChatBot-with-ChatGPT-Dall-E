import 'package:chatgptv1/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xff00A67E),
            onPrimary: Colors.white,
            secondary: Colors.white,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.red,
            background: Color(0xffffffff),
            onBackground: Color(0xffffffff),
            surface: Color(0xff00A67E),
            onSurface: Color(0xffffffff), //text color
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
