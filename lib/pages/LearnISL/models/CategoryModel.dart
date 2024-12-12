import 'package:flutter/cupertino.dart';

class CategoryModel {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final Widget detailedPage;

  CategoryModel({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.detailedPage,
  });
}