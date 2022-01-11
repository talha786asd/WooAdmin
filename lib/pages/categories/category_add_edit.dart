import 'package:admin_app/enum/page_type.dart';
import 'package:admin_app/models/category_model.dart';
import 'package:admin_app/pages/base_page.dart';
import 'package:admin_app/provider/categories_provider.dart';
import 'package:admin_app/provider/loader_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class CategoryAddEditPage extends BasePage {
  final PageType? pageType;
  final CategoryModel? model;

  CategoryAddEditPage({this.pageType, this.model});

  @override
  _CategoryAddEditPageState createState() => _CategoryAddEditPageState();
}

class _CategoryAddEditPageState extends BasePageState<CategoryAddEditPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  CategoryModel? categoryModel;

  @override
  void initState() {
    super.initState();
    this.pageTitle =
        this.widget.pageType == PageType.Add ? "Add Category" : "Edit Category";
    if (this.widget.pageType == PageType.Edit) {
      this.categoryModel = this.widget.model!;
    } else {
      this.categoryModel = CategoryModel();
    }
  }

  @override
  Widget get pageUI {
    return Form(
      key: globalKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormHelper.inputFieldWidgetWithLabel(
                  context, Icon(Icons.ac_unit), "name", "Category Name", "",
                  (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "Category Name can\'t be empty";
                }
                return null;
              }, (onSavedVal) {
                this.categoryModel!.name = onSavedVal;
              },
                  initialValue: this.categoryModel!.name!,
                  borderColor: Theme.of(context).primaryColor,
                  borderFocusColor: Theme.of(context).primaryColor,
                  showPrefixIcon: false,
                  borderRadius: 10,
                  paddingLeft: 0,
                  paddingRight: 0),
              FormHelper.inputFieldWidgetWithLabel(context, Icon(Icons.ac_unit),
                  "description", "Category Description", "", (onValidateVal) {
                return null;
              }, (onSavedVal) {
                this.categoryModel!.description = onSavedVal;
              },
                  initialValue: this.categoryModel!.description!,
                  borderColor: Theme.of(context).primaryColor,
                  borderFocusColor: Theme.of(context).primaryColor,
                  showPrefixIcon: false,
                  borderRadius: 10,
                  paddingLeft: 0,
                  paddingRight: 0,
                  isMultiline: true,
                  containerHeight: 200),
              SizedBox(
                height: 20,
              ),
              Center(
                child: FormHelper.submitButton("Save", () {
                  if (validateAndSave()) {
                    Provider.of<LoaderProvider>(context, listen: false)
                        .setLoadingStatus(true);

                    if (this.widget.pageType == PageType.Add) {
                      Provider.of<CategoriesProvider>(context, listen: false)
                          .createCategory(categoryModel!, (val) {
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(false);

                        if (val) {
                          Get.snackbar("Admin App", "Category Created",
                              snackPosition: SnackPosition.BOTTOM,
                              duration: Duration(seconds: 3));
                        }
                      });
                    }
                  }
                  else{
                        Provider.of<LoaderProvider>(context, listen: false)
                        .setLoadingStatus(true);

                    if (this.widget.pageType == PageType.Add) {
                      Provider.of<CategoriesProvider>(context, listen: false)
                          .updateCategory(categoryModel!, (val) {
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(false);

                        if (val) {
                          Get.snackbar("Admin App", "Category Modified",
                              snackPosition: SnackPosition.BOTTOM,
                              duration: Duration(seconds: 3));
                        }
                      });
                    }
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
