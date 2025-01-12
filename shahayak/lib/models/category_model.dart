import 'package:flutter/material.dart';

class CategoryModel {
  final String? categoryName;
  final Color boxColor;

  CategoryModel({this.categoryName, required this.boxColor});

  // A method to get a list of categories (you can customize this with actual data)
  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(categoryName: 'Technology', boxColor: Colors.blue),
      CategoryModel(categoryName: 'Education', boxColor: Colors.green),
      CategoryModel(categoryName: 'Health', boxColor: Colors.red),
      CategoryModel(categoryName: 'Sports', boxColor: Colors.orange),
      CategoryModel(categoryName: 'Fashion', boxColor: Colors.purple),
      CategoryModel(categoryName: 'Food', boxColor: Colors.yellow),
    ];
  }
}
