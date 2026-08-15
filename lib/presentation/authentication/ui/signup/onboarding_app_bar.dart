import '/app_exports.dart';

/// Shared app bar for the 5-step signup flow: back button + "Step X/5" badge
/// on top, thin progress bar underneath.
///
/// NOTE: `Color(0xFFB4D426)` is a placeholder for the lime-green accent used
/// throughout the designs — swap it for your real theme color constant.
class OnboardingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  const OnboardingAppBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kWhiteColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: onBack ?? () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, size: 20, color: kBlackColor),
                  6.widthBox,
                  Text(
                    "Back",
                    style: AppStyles.titleRegular.copyWith(color: kBlackColor),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: kBorderColor),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Step $currentStep/$totalSteps",
                style: AppStyles.titleRegular.copyWith(
                  color: kTextColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: ClipRRect(
          child: LinearProgressIndicator(
            value: currentStep / totalSteps,
            minHeight: 4,
            backgroundColor: kBorderColor.withOpacity(0.25),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB4D426)),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);
}
