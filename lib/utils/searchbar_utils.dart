
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class SearchBarUtils {
  static Widget searchBar(
    BuildContext context,
    String keyName,
    String placeHolder,
    String addButtonLabel,
    Function onSearchTab,
    Function onAddButtonTab,
  ) {
    String val = "";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FormHelper.inputFieldWidget(
          context,
          Icon(Icons.web),
          keyName,
          placeHolder,
          () {},
          () {},
          onChange: (onChangedVal) => {val = onChangedVal},
          showPrefixIcon: false,
          suffixIcon: Container(
            child: GestureDetector(
              child: Icon(Icons.search),
              onTap: () {
                return onSearchTab(val);
              },
            ),
          ),
          borderFocusColor: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
          borderRadius: 10,
          paddingLeft: 0,
          
          
        ),
        FormHelper.submitButton(addButtonLabel, () {
          return onAddButtonTab();
        },
        borderRadius: 10,
        width: 100,
        fontSize: 12
        )
      ],
    );
  }
}
