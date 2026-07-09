import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final fullNameController = TextEditingController();
  final selectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    // Retrieve current details from ProfileController
    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>();
      fullNameController.text = profile.displayName.value;
      selectedImage.value = profile.profileImage.value;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    super.onClose();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Image Selection Error',
        'Failed to select image: $e',
        backgroundColor: const Color(0xFFFF6C6C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  void saveChanges() {
    final newName = fullNameController.text.trim();
    if (newName.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Name cannot be empty',
        backgroundColor: const Color(0xFFFF6C6C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>();
      profile.updateProfile(
        newName: newName,
        newImage: selectedImage.value,
      );
    }

    Get.back();
    Get.snackbar(
      'Profile Updated',
      'Your profile details have been saved!',
      backgroundColor: const Color(0xFF10B981), // Emerald green
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
