import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscureCurrentPassword = true.obs;
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleCurrentPasswordVisibility() {
    obscureCurrentPassword.value = !obscureCurrentPassword.value;
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void updatePassword() async {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (currentPassword.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Current password is required',
        backgroundColor: const Color(0xFFFF6C6C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword.isEmpty || newPassword.length < 6) {
      Get.snackbar(
        'Validation Error',
        'New password must be at least 6 characters',
        backgroundColor: const Color(0xFFFF6C6C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Validation Error',
        'New passwords do not match',
        backgroundColor: const Color(0xFFFF6C6C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Mock password update logic
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(milliseconds: 1500));
    Get.back(); // close progress dialog

    // Clear fields
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    Get.back(); // navigate back to Settings page
    Get.snackbar(
      'Success',
      'Password updated successfully!',
      backgroundColor: const Color(0xFF10B981), // Emerald green
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
