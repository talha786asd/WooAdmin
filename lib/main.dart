import 'package:admin_app/pages/base_page.dart';
import 'package:admin_app/pages/categories/categories_list.dart';
import 'package:admin_app/pages/home_page.dart';
import 'package:admin_app/pages/login_page.dart';
import 'package:admin_app/provider/categories_provider.dart';
import 'package:admin_app/provider/loader_provider.dart';
import 'package:admin_app/provider/searchbar_provider.dart';
import 'package:admin_app/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Widget _defaultHome = LoginPage();
void main() async {
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoriesProvider(),
          child: CategoriesList(),
        ),
          ChangeNotifierProvider(
          create: (context) => SearchBarProvider(),
          child: BasePage(),
        ),
         ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: BasePage(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.purpleAccent),
        home: HomePage(),
      ),
    );
  }
}
