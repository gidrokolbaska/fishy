import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref) => DarkModeNotifier(),
);

///Provider which initializes the shared preferences and can be used later on
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) {
    throw UnimplementedError();
  },
);

class DarkModeNotifier extends StateNotifier<bool> {
  late SharedPreferences prefs;

  Future _init() async {
    var darkMode = prefs.getBool("darkMode");
    state = darkMode ?? false;
  }

  DarkModeNotifier() : super(false) {
    _init();
  }

  void toggle() async {
    state = !state;
    prefs.setBool("darkMode", state);
  }
}
