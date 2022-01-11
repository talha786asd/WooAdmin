import 'package:admin_app/models/category_model.dart';
import 'package:admin_app/services/api_service.dart';
import 'package:flutter/material.dart';

class CategoriesProvider with ChangeNotifier {
  APIService? _apiService;

  List<CategoryModel>? _categoriesList;
  List<CategoryModel> get categoriesList => _categoriesList!;

  double get totalRecords => _categoriesList!.length.toDouble();

  CategoriesProvider() {
    _apiService = APIService();
    _categoriesList = null;
  }

  resetStreams() {
    _apiService = APIService();
    _categoriesList = null;

    notifyListeners();
  }

  fetchCategories({
    String? strSearch,
    String? sortBy,
    String? sortOrder,
  }) async {
    List<CategoryModel>? categoriesList = await _apiService!.getCategories(
        strSearch: strSearch, sortBy: sortBy, sortOrder: sortOrder);

    if (_categoriesList == null) {
      _categoriesList = List<CategoryModel>.empty(growable: true);
    }

    if (categoriesList!.length > 0) {
      _categoriesList = [];
      _categoriesList!.addAll(categoriesList);
    }
    notifyListeners();
  }

  createCategory(CategoryModel model, Function onCallBack) async {
    CategoryModel? _categoryModel = await _apiService!.createCategory(model);

    if (_categoryModel != null) {
      _categoriesList!.add(_categoryModel);
      onCallBack(true);
    } else {
      onCallBack(false);
    }
    notifyListeners();
  }

  updateCategory(CategoryModel model, Function onCallBack) async {
    CategoryModel? _categoryModel = await _apiService!.updateCategory(model);

    if (_categoryModel != null) {
      _categoriesList!.remove(model);
      _categoriesList!.add(_categoryModel);
      onCallBack(true);
    } else {
      onCallBack(false);
    }
    notifyListeners();
  }

  deleteCategory(CategoryModel model, Function onCallBack) async {
    bool? isDeleted = await _apiService!.deleteCategory(model);

    if (isDeleted!) {
      _categoriesList!.remove(model);
    }
    onCallBack(isDeleted);
    notifyListeners();
  }
}
