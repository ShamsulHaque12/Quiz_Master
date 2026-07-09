import 'package:flutter/material.dart';

class ProfileStatModel {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const ProfileStatModel({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });
}
