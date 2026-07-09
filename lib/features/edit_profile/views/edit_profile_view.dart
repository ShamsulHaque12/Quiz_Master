import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20), // Obsidian Space Dark
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title Header
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text('👤', style: TextStyle(fontSize: 24.sp)),
                  SizedBox(width: 10.w),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 6.h, left: 4.w),
                child: Text(
                  'Manage your display identity and profile picture',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),

            // Profile Avatar Picker Stack
            Stack(
              children: [
                Obx(() {
                  final imageFile = controller.selectedImage.value;
                  return Container(
                    width: 110.r,
                    height: 110.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0072FF).withValues(alpha: 0.25),
                          blurRadius: 20.r,
                          spreadRadius: 1.r,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(3.r),
                      child: ClipOval(
                        child: imageFile != null
                            ? Image.file(imageFile, fit: BoxFit.cover)
                            : Container(
                                color: const Color(0xFF161233),
                                child: Center(
                                  child: Text('😊', style: TextStyle(fontSize: 54.sp)),
                                ),
                              ),
                      ),
                    ),
                  );
                }),
                // Edit overlay button
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _showImageSourceSheet(context),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6C63FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 18.r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),

            // Full Name Input Card
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'FULL NAME',
                style: TextStyle(
                  color: const Color(0xFF8B5CF6),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.015),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: TextField(
                controller: controller.fullNameController,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your full name',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 14.sp,
                  ),
                  icon: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white.withValues(alpha: 0.45),
                    size: 20.r,
                  ),
                ),
              ),
            ),
            SizedBox(height: 48.h),

            // Save Changes Button
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4A00E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                      blurRadius: 12.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: controller.saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: const Color(0xFF161233),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.04),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Profile Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSourceButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () {
                      Get.back();
                      controller.pickImage(ImageSource.gallery);
                    },
                  ),
                  _buildSourceButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () {
                      Get.back();
                      controller.pickImage(ImageSource.camera);
                    },
                  ),
                  _buildSourceButton(
                    icon: Icons.delete_outline_rounded,
                    label: 'Remove',
                    color: Colors.redAccent,
                    onTap: () {
                      Get.back();
                      controller.removeImage();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = const Color(0xFF6C63FF),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 24.r),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
