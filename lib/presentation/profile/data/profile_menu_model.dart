// lib/screens/vendor/profile/data/profile_menu_model.dart

import 'package:flutter/material.dart';

class ProfileMenuItem {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });
}
