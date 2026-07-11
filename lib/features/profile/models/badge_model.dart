import '../controllers/profile_controller.dart';

class BadgeModel {
  final int id;
  final String imagePath;
  final String title;
  final String description;
  final bool Function(ProfileController controller) isUnlocked;

  const BadgeModel({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.isUnlocked,
  });
}
