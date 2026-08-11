import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../profile/controllers/profile_controller.dart';
import '../../../home/controllers/home_controller.dart';

class SignUpController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  File? _profileImage;

  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get isLoading => _isLoading;
  File? get profileImage => _profileImage;

  String? get fullNameError => _fullNameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;

  @override
  void onInit() {
    super.onInit();
    fullNameController.addListener(_clearFullNameError);
    emailController.addListener(_clearEmailError);
    passwordController.addListener(_clearPasswordError);
    confirmPasswordController.addListener(_clearConfirmPasswordError);
  }

  @override
  void onClose() {
    fullNameController.removeListener(_clearFullNameError);
    emailController.removeListener(_clearEmailError);
    passwordController.removeListener(_clearPasswordError);
    confirmPasswordController.removeListener(_clearConfirmPasswordError);
    super.onClose();
  }

  void _clearFullNameError() {
    if (_fullNameError != null) {
      _fullNameError = null;
      update();
    }
  }

  void _clearEmailError() {
    if (_emailError != null) {
      _emailError = null;
      update();
    }
  }

  void _clearPasswordError() {
    if (_passwordError != null) {
      _passwordError = null;
      update();
    }
  }

  void _clearConfirmPasswordError() {
    if (_confirmPasswordError != null) {
      _confirmPasswordError = null;
      update();
    }
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    update();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    update();
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
        _profileImage = File(pickedFile.path);
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Image Selection Error',
        'Failed to retrieve image: $e',
        backgroundColor: const Color(0xFFFF6C6C),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void removeImage() {
    _profileImage = null;
    update();
  }

  Future<bool> signUp() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    _fullNameError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    bool hasError = false;

    // Full name validation
    if (fullName.isEmpty) {
      _fullNameError = 'Full name cannot be empty';
      hasError = true;
    } else if (fullName.length < 3) {
      _fullNameError = 'Name must be at least 3 characters';
      hasError = true;
    }

    // Email validation
    if (email.isEmpty) {
      _emailError = 'Email address cannot be empty';
      hasError = true;
    } else {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        _emailError = 'Please enter a valid email address';
        hasError = true;
      }
    }

    // Password validation
    if (password.isEmpty) {
      _passwordError = 'Password cannot be empty';
      hasError = true;
    } else if (password.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
      hasError = true;
    }

    // Confirm password validation
    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'Please confirm your password';
      hasError = true;
    } else if (confirmPassword != password) {
      _confirmPasswordError = 'Passwords do not match';
      hasError = true;
    }

    if (hasError) {
      update();
      return false;
    }

    _isLoading = true;
    update();

    // Pure UI simulation delay
    await Future.delayed(const Duration(milliseconds: 600));

    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>();
      profile.displayName.value = fullName;
      profile.email.value = email;
      if (_profileImage != null) {
        profile.profileImage.value = _profileImage;
      }
    }

    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      home.displayName.value = fullName;
    }

    _isLoading = false;
    update();
    return true;
  }
}
