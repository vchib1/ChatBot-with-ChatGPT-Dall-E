import '../utils/exports.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();

  //instance of shared preference
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
        ChangeNotifierProvider(create: (context) => ThemeProvider(isDark),),
        ChangeNotifierProvider(create: (context) => SpeechProvider(),),
        ChangeNotifierProvider(create: (context) => MessageProvider(),),
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
