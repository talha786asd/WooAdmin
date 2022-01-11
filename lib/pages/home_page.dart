import 'package:admin_app/pages/categories/categories_list.dart';
import 'package:admin_app/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class NavBarModel {
  String? title;
  IconData? icon;
  String? color;

  NavBarModel(this.title, this.icon, this.color);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<NavBarModel> _titleList = [
    NavBarModel("Dashboard", Icons.home, "#00B8E0"),
    NavBarModel("Categories", Icons.category, "#A50606"),
    NavBarModel("Products", Icons.image, "#6D7600"),
    NavBarModel("Customers", Icons.group, "#450FE0"),
    NavBarModel("Orders", Icons.shopping_basket, "#C604CA"),
  ];

  List<Widget> _widgetList = [
    Container(),
    CategoriesList(),
    Container(),
    Container(),
    Container(),


  ];

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: _titleList.map(
          (NavBarModel model) {
            return BottomNavigationBarItem(
                icon: Icon(
                  model.icon,
                  color: HexColor(model.color!),
                ),
                label: model.title);
          },
        ).toList(),
      ),
      body: _widgetList[_index]
    );
  }
}
