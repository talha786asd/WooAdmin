import 'package:admin_app/provider/loader_provider.dart';
import 'package:admin_app/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
    GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String pageTitle = "";
  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return  Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                SharedService.logout();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: ProgressHUD(
        key: globalKey,
        child: pageUI!,
        inAsyncCall: loaderModel.isApiCallProcess,
        opacity: 0.3, 
        ),
    );
    });

  }

  Widget? get pageUI  {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
