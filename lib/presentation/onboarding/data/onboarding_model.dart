import '../../../generated/assets.dart';

class OnboardingData {
  final String image;
  final String title;
  final String subtitle;

  OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

final List<OnboardingData> onboardingPages = [
  OnboardingData(
    image: Assets.png.onboardingOne.path,
    title: "Find the best courts\n near you.",
    subtitle:
        "Discover premium basketball, tennis, and pickleball courts in your area with ease.",
  ),
  OnboardingData(
    image: Assets.png.onboardingTwo.path,
    title: "Join open matches and\n meet new players",
    subtitle:
        "Find local games, level up your skills, and expand your sports circle effortlessly.",
  ),
  OnboardingData(
    image: Assets.png.onboardingThree.path,
    title: "Book Courts & Play\n Matches",
    subtitle: "Book instantly and hit the court with your favorite partners.",
  ),
];
