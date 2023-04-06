import '../utils/exports.dart';

class ThemeProvider with ChangeNotifier{

  ThemeMode _currentTheme = ThemeMode.light;
  ThemeMode get currentTheme => _currentTheme;

  //bool isDark = false;

  ThemeProvider(bool isDark) {
    if(isDark){
      _currentTheme = ThemeMode.dark;
    }else{
      _currentTheme = ThemeMode.light;
    }
  }

  void toggleTheme()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(_currentTheme == ThemeMode.light) {
      _currentTheme = ThemeMode.dark;
      pref.setBool("isDark", true);
    }else{
      _currentTheme = ThemeMode.light;
      pref.setBool("isDark", false);
    }
    notifyListeners();
  }
}