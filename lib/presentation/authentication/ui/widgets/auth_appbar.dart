import 'package:quadraclub_app/app_exports.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int? totalStages;
  final int currentStage;
  final bool showBackButton;
  final String? title;

  const AuthAppBar({
    super.key,
    this.totalStages,
    this.currentStage = 0,
    this.showBackButton = true,
    this.title,
  }) : assert(
         totalStages == null || currentStage > 0 && currentStage <= totalStages,
         'currentStage must be between 1 and totalStages.',
       );

  @override
  Widget build(BuildContext context) {
    Widget? titleWidget;
    if (totalStages != null && totalStages! > 0) {
      titleWidget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalStages!, (index) {
          final isCompleted = index + 1 <= currentStage;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: isCompleted
                  ? kSecondaryColor
                  : kTertiaryColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      );
    } else if (title != null) {
      titleWidget = Text(
        title!,
        style: AppStyles.headingSemibold.copyWith(
          color: kBlackColor,
          fontSize: 20,
        ),
      );
    }

    return AppBar(
      backgroundColor: kWhiteColor,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        // Black icons for white appbar
        statusBarBrightness: Brightness.light, // For iOS
      ),
      // The default Flutter back button is disabled
      automaticallyImplyLeading: false,

      // Control the back button based on showBackButton
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: kBlackColor),
              onPressed: () => Navigator.pop(context),
            )
          : const SizedBox(width: 48),

      // Use empty space to balance the trailing action, or match size of back button
      title: titleWidget,

      // Use a fixed width SizedBox in actions to visually center the title/indicator
      // when the 'leading' widgets is an IconButton (which is 48 wide).
      actions: const [SizedBox(width: 48)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
