import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A versioned snapshot; sensitive credentials never enter this store.
class LocalStore {
  final SharedPreferences preferences;
  LocalStore(this.preferences);
  static Future<LocalStore> open() async =>
      LocalStore(await SharedPreferences.getInstance());
  Map<String, dynamic> read() {
    try {
      return jsonDecode(preferences.getString('burger.v1') ?? '{}')
          as Map<String, dynamic>;
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }

  Future<void> write(Map<String, dynamic> data) async {
    await preferences.setString('burger.v1', jsonEncode(data));
  }
}
