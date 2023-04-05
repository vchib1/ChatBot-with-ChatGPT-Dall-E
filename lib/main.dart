import 'package:chatgptv1/constants/themes.dart';
import 'package:chatgptv1/pages/home_page.dart';
import 'package:chatgptv1/providers/speech_provider.dart';
import 'package:chatgptv1/providers/theme_provider.dart';
import 'package:chatgptv1/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences pref = await SharedPreferences.getInstance();
  bool? isDark = pref.getBool("isDark") ?? false;

  runApp(MyApp(isDark: isDark,));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  const MyApp({super.key,required this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApiClass(),),
        ChangeNotifierProvider(create: (context) => ThemeProvider(isDark),),
        ChangeNotifierProvider(create: (context) => SpeechProvider(),),
      ],
      child: ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(isDark),
        builder: (context, provider) {
          return MaterialApp(
            title: 'ChatGPT',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: context.watch<ThemeProvider>().currentTheme,
            home: const HomePage(),
          );
        }
      ),
    );
  }
}
