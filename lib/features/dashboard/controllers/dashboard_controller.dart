import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final _currentIndex = 0.obs;
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  // Gamification stats
  final userLevel = 12.obs;
  final currentXP = 1250.obs;
  final nextLevelXP = 2000.obs;

  int get currentIndex => _currentIndex.value;
  double get levelProgress => currentXP.value / nextLevelXP.value;

  void changeTabIndex(int index) {
    _currentIndex.value = index;
    // Clear search when switching tabs
    if (index != 1) {
      clearSearch();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
