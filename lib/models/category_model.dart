import 'dart:convert';

CategoryModel categoryFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

List<CategoryModel> categoriesFromJson(dynamic str) =>
    List<CategoryModel>.from((str).map((x) => CategoryModel.fromJson(x)));

class CategoryModel {
  int? id;
  String? name;
  int? parent;
  String? description;
  String? image;

  CategoryModel(
      {this.id, this.description, this.image, this.name, this.parent});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString().replaceAll("&amp;", "&");
    parent = json['parent'];
    description = json['description'].toString().replaceAll("&amp;", "&");
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent'] = this.parent;
    data['description'] = this.description;
    data['image'] = this.image;

    return data;
  }
}
