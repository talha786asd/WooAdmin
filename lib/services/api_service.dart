import 'dart:convert';

import 'package:admin_app/models/category_model.dart';
import 'package:admin_app/models/login_model.dart';
import 'package:admin_app/services/shared_service.dart';
import 'package:http/http.dart' as http;

class APIService {
  static var client = http.Client();

  static Future<bool> checkLogin(LoginModel model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.https(model.host!, "/wp-json/wc/v3/products", {
      "consumer_key": model.key,
      "consumer_secret": model.secret,
    });

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(model);
      return true;
    } else {
      return false;
    }
  }

  Future<List<CategoryModel>?> getCategories({
    String? strSearch,
    String? sortBy,
    String? sortOrder = "asc",
    bool parentCategories = true,
  }) async {
    Map<String, String> requestHeaders = {'Content-Type': 'appliction/json'};

    var loginDetails = await SharedService.loginDetails();

    Map<String, String> queryString = {
      'consumer_key': loginDetails!.key!,
      'consumer_secret': loginDetails.secret!,
    };

    if (strSearch != null) {
      queryString['search'] = strSearch;
    }
    if (parentCategories) {
      queryString['parent'] = "0";
    }

    if (sortBy != null) {
      queryString['orderBy'] = sortBy;
    }
    if (sortOrder != null) {
      queryString['order'] = sortOrder;
    }
    var url = Uri.https(
        loginDetails.host!, "/wp-json-wc/w3/products/categories", queryString);

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      return categoriesFromJson(
        json.decode(response.body),
      );
    } else {
      return null;
    }
  }

  Future<CategoryModel?> createCategory(CategoryModel model) async {
    var loginDetails = await SharedService.loginDetails();

    var authToken = base64
        .encode(utf8.encode(loginDetails!.key! + ":" + loginDetails.secret!));

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'authorization': 'Basic $authToken'
    };
    var url =
        Uri.https(loginDetails.host!, "/wp-json/wc/v3/products/categories");

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    if (response.statusCode == 201) {
      return categoryFromJson(response.body);
    } else {
      return null;
    }
  }

   Future<CategoryModel?> updateCategory(CategoryModel model) async{
      var loginDetails = await SharedService.loginDetails();

       var authToken = base64
        .encode(utf8.encode(loginDetails!.key! + ":" + loginDetails.secret!));

         Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'authorization': 'Basic $authToken'
    };
     var url =
        Uri.https(loginDetails.host!, "/wp-json/wc/v3/products/categories/" + model.id.toString());
         var response = await client.put(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

         if (response.statusCode == 200) {
      return categoryFromJson(response.body);
    }
    else {
      return null;
    }

   }
   
   Future<bool?> deleteCategory(CategoryModel model) async{
      var loginDetails = await SharedService.loginDetails();

       var authToken = base64
        .encode(utf8.encode(loginDetails!.key! + ":" + loginDetails.secret!));

         Map<String, String> requestHeaders = {
      'authorization': 'Basic $authToken'
    };
     var url =
        Uri.https(loginDetails.host!, "/wp-json/wc/v3/products/categories/" + model.id.toString(),

        {
          "force": "true"
        }
        
        );
         var response = await client.delete(url,
        headers: requestHeaders);

         if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }

   }
}
