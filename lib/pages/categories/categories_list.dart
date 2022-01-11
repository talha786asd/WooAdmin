import 'package:admin_app/enum/page_type.dart';
import 'package:admin_app/models/category_model.dart';
import 'package:admin_app/pages/base_page.dart';
import 'package:admin_app/pages/categories/category_add_edit.dart';
import 'package:admin_app/provider/categories_provider.dart';
import 'package:admin_app/provider/loader_provider.dart';
import 'package:admin_app/provider/searchbar_provider.dart';
import 'package:admin_app/utils/searchbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/list_helper.dart';

class CategoriesList extends BasePage {
  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends BasePageState<CategoriesList> {
  // List<CategoryModel>? categories;
  @override
  void initState() {
    super.initState();
    this.pageTitle = "Categories";

    var categoryProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    categoryProvider.fetchCategories();
  }

  @override
  Widget get pageUI {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SearchBarUtils.searchBar(
                context, "strCategory", "Search Category", "Add Category",
                (val) {
              SortModel sortModel =
                  Provider.of<SearchBarProvider>(context, listen: false)
                      .sortModel;
              var categoryProvider =
                  Provider.of<CategoriesProvider>(context, listen: false);
              categoryProvider.resetStreams();
              categoryProvider.fetchCategories(
                sortBy: sortModel.sortColumnName,
                sortOrder: sortModel.sortAscending! ? "asc" : "desc",
                strSearch: val,
              );
            }, () {
              Get.to(() => CategoryAddEditPage(
                    pageType: PageType.Add,
                  ));
            }),
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          categoriesListUI(),
        ],
      ),
    );
  }

  Widget categoriesListUI() {
    return Consumer<CategoriesProvider>(builder: (context, model, child) {
      if (model.categoriesList != null && model.categoriesList.length > 0) {
        return ListUtils.buildDataTable<CategoryModel>(
            context,
            ["Name", "Description", ""],
            ["name", "description", ""],
            Provider.of<SearchBarProvider>(context, listen: true)
                .sortModel
                .sortAscending!,
            Provider.of<SearchBarProvider>(context, listen: true)
                .sortModel
                .sortColumnIndex!,
            model.categoriesList,
            (CategoryModel onEditVal) {
              print(onEditVal.id);
              print(onEditVal.name);

              Get.to(() => CategoryAddEditPage(
                    pageType: PageType.Edit,
                    model: onEditVal,
                  ));
            },
            (CategoryModel onDeleteVal) {
              print(onDeleteVal.id);
              print(onDeleteVal.name);

              Provider.of<LoaderProvider>(context, listen: false)
                  .setLoadingStatus(true);
              Provider.of<CategoriesProvider>(context, listen: false)
                  .deleteCategory(onDeleteVal, (val) {
                Provider.of<LoaderProvider>(context, listen: false)
                    .setLoadingStatus(false);

                if (val) {
                  Get.snackbar("Admin App", "Category Deleted",
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 5));
                }
              });
            },
            headingRowColor: Theme.of(context).primaryColor,
            headingRowHeight: 50,
            onSort: (columnIndex, columnName, ascending) {
              Provider.of<SearchBarProvider>(context, listen: false)
                  .setSort(columnIndex, columnName, ascending);
              var categoryProvider =
                  Provider.of<CategoriesProvider>(context, listen: false);
              categoryProvider.resetStreams();
              categoryProvider.fetchCategories(
                sortBy: columnName,
                sortOrder: ascending ? "asc" : "desc",
              );
            });
      }

      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
