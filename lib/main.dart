import 'package:admin_app/pages/home_page.dart';
import 'package:admin_app/pages/login_page.dart';
import 'package:admin_app/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget _defaultHome = LoginPage();
void main() async{
 WidgetsFlutterBinding.ensureInitialized();

 bool _result = await SharedService.isLoggedIn();

  if (_result) {
    _defaultHome = HomePage();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.purpleAccent
      ),
      home: _defaultHome,
    );
  }
}
