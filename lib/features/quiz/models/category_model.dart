import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final Widget icon;
  final Gradient gradient;

  const CategoryModel({
    required this.name,
    required this.icon,
    required this.gradient,
  });
}
