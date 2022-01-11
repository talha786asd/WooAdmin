import 'package:flutter/cupertino.dart';

class SortModel {
  int? sortColumnIndex;
  String? sortColumnName;
  bool? sortAscending;

  SortModel({this.sortAscending, this.sortColumnIndex, this.sortColumnName});
}

class SearchBarProvider with ChangeNotifier {
  SortModel? _sortModel;
  SortModel get sortModel => _sortModel!;

  SearchBarProvider() {
    _sortModel = SortModel();
    _sortModel!.sortColumnIndex = 0;
    _sortModel!.sortAscending = false;
  }

  setSort(int columnIndex, String sortColumnName, bool asending) {
    _sortModel!.sortAscending = asending;
    _sortModel!.sortColumnIndex = columnIndex;
    _sortModel!.sortColumnName = sortColumnName;

    notifyListeners();
  }
}
