import '../utils/exports.dart';

ThemeData lightTheme = ThemeData(

  primaryColor: primaryColor,
  brightness: Brightness.light,

  iconTheme: const IconThemeData(
    color: Colors.white
  ),

  popupMenuTheme: const PopupMenuThemeData(
      color: primaryColor
  ),

  appBarTheme: const AppBarTheme(
      color: primaryColor
  ),

  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
    hintStyle: TextStyle(fontSize: 16,color: Colors.white),
  ),

  primaryTextTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16,color: Colors.white),
  ),

  useMaterial3: true,
);

ThemeData darkTheme = ThemeData(

  primaryColor: Colors.grey.shade800,
  scaffoldBackgroundColor: Colors.black,
  brightness: Brightness.dark,

  iconTheme: const IconThemeData(
      color: Colors.white
  ),

  popupMenuTheme: const PopupMenuThemeData(
      color: Colors.black
  ),

  appBarTheme: AppBarTheme(
      color: Colors.grey.shade800
  ),

  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
    hintStyle: TextStyle(fontSize: 16,color: Colors.white),
  ),

  primaryTextTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16,color: Colors.white),
  ),

  useMaterial3: true,
);