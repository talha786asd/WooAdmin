import 'dart:convert';

import 'package:admin_app/models/login_model.dart';
import 'package:admin_app/pages/login_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static Future<bool> setLoginDetails(LoginModel? model) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(
      "login_details",
      model != null ? jsonEncode(model.toJson()) : "null",
    );
  }

  static Future<LoginModel?> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('login_details') != "null" &&
            prefs.getString('login_details') != null
        ? LoginModel.fromJson(
            jsonDecode(
              prefs.getString('login_details')!,
            ),
          )
        : null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return (prefs.getString("login_details") != "null" &&
            prefs.getString("login_details") != null)
        ? true
        : false;
  }

  static Future<void> logout() async {
    await setLoginDetails(null);

    Get.offAll(() => LoginPage());
  }
}
