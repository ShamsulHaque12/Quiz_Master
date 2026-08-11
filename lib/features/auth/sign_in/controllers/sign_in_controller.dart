import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../profile/controllers/profile_controller.dart';
import '../../../home/controllers/home_controller.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  String? _emailError;
  String? _passwordError;

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_clearEmailError);
    passwordController.addListener(_clearPasswordError);
  }

  @override
  void onClose() {
    emailController.removeListener(_clearEmailError);
    passwordController.removeListener(_clearPasswordError);
    super.onClose();
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

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    update();
  }

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    update();
  }

  Future<bool> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    _emailError = null;
    _passwordError = null;
    bool hasError = false;

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

    if (password.isEmpty) {
      _passwordError = 'Password cannot be empty';
      hasError = true;
    } else if (password.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
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

    // Update Profile and Home controllers if registered
    final username = email.split('@').first;
    final formattedName = username.isEmpty
        ? 'Quiz Master'
        : username[0].toUpperCase() + username.substring(1);

    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>();
      profile.displayName.value = formattedName;
      profile.email.value = email;
    }

    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      home.displayName.value = formattedName;
    }

    _isLoading = false;
    update();
    return true;
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    update();

    await Future.delayed(const Duration(milliseconds: 800));

    const googleName = 'Alex Hunter';
    const googleEmail = 'alex.hunter@example.com';

    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>();
      profile.displayName.value = googleName;
      profile.email.value = googleEmail;
    }

    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      home.displayName.value = googleName;
    }

    _isLoading = false;
    update();
    return true;
  }

  bool playAsGuest() {
    if (Get.isRegistered<ProfileController>()) {
      final profile = Get.find<ProfileController>();
      profile.displayName.value = 'Guest Player';
      profile.email.value = 'guest@quizmaster.app';
    }

    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      home.displayName.value = 'Guest Player';
    }
    return true;
  }
}
