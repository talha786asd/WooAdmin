import 'package:admin_app/models/login_model.dart';
import 'package:admin_app/pages/home_page.dart';
import 'package:admin_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  LoginModel? loginModel;

  @override
  void initState() {
    super.initState();
    loginModel = LoginModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[200],
      body: ProgressHUD(
        key: globalFormKey,
        child: Form(key: globalFormKey, child: _loginUI(context)),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      ),
    ));
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                    ]),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(150),
                  bottomLeft: Radius.circular(150),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Woo Admin",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  "Admin Login",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FormHelper.inputFieldWidget(
                context,
                const Icon(Icons.web),
                "host",
                "Host URL",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return 'Host URL can\'t be empty';
                  }
                  return null;
                },
                (onSavedVal) {
                  this.loginModel!.host = onSavedVal;
                },
                initialValue: this.loginModel!.host!,
                borderFocusColor: Theme.of(context).primaryColor,
                prefixIconColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FormHelper.inputFieldWidget(
                context,
                const Icon(Icons.lock),
                "key",
                "Consumer Key",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return 'Consumer Key can\'t be empty';
                  }
                  return null;
                },
                (onSavedVal) {
                  this.loginModel!.key = onSavedVal;
                },
                initialValue: this.loginModel!.key!,
                borderFocusColor: Theme.of(context).primaryColor,
                prefixIconColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FormHelper.inputFieldWidget(
                context,
                const Icon(Icons.web),
                "key",
                "Consumer Secret",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return 'Consumer Secret can\'t be empty';
                  }
                  return null;
                },
                (onSavedVal) {
                  this.loginModel!.secret = onSavedVal;
                },
                initialValue: this.loginModel!.secret!,
                borderFocusColor: Theme.of(context).primaryColor,
                prefixIconColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
              ),
            ),
            const Center(
              child: Text(
                "OR",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Center(
              child: GestureDetector(
                child: const Icon(
                  Icons.qr_code,
                  size: 100,
                ),
                onTap: () async {
                  await scanQR();
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FormHelper.submitButton("Login", () {
                if (validateAndSave()) {
                  setState(() {
                    this.isApiCallProcess = true;
                  });

                  APIService.checkLogin(this.loginModel!).then((response) {
                    setState(() {
                      this.isApiCallProcess = false;
                    });
                    if (response) {
                      Get.offAll(() => HomePage());
                    } else {
                      FormHelper.showSimpleAlertDialog(
                          context, "WooAdmin", "Invalid Details!", "OK", () {
                        setState(() {
                          this.loginModel!.key = "";
                          this.loginModel!.secret = "";
                        });

                        Navigator.of(context).pop();
                      });
                    }
                  });
                }
              },
                  borderColor: Theme.of(context).primaryColor,
                  btnColor: Theme.of(context).primaryColor,
                  txtColor: Colors.black),
            )
          ]),
    );
  }

  Future<void> scanQR() async {
    String? barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
    } on PlatformException {}

    if (!mounted) return;
    setState(() {
      if (barcodeScanRes!.isNotEmpty) {
        this.loginModel!.key = barcodeScanRes.split("|")[0];
        this.loginModel!.secret = barcodeScanRes.split("|")[1];
      }
    });
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
