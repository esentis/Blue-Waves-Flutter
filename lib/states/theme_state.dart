import 'package:blue_waves/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ThemeState extends ChangeNotifier {
  static ThemeState of(BuildContext context, {bool listen = false}) {
    return Provider.of<ThemeState>(context, listen: listen);
  }

  bool isDark;
  bool get getIsDark => isDark;

  void toggleTheme() {
    log.wtf('Toggling theme');
    isDark = !isDark;
    notifyListeners();
  }

  ThemeState({
    required this.isDark,
  });
}
