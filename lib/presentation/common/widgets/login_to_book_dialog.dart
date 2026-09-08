import 'package:quadraclub_app/app_exports.dart';

/// Modal bottom sheet shown when an unauthenticated user tries to book
/// a court or class. Matches the design in the attached screenshot.
class LoginToBookDialog extends StatelessWidget {
  final String title;
  final String subtitle;

  const LoginToBookDialog({
    super.key,
    this.title = 'Sign in to book this court',
    this.subtitle = 'Please log in or create an account to reserve your spot.',
  });

  /// Convenience method to show the bottom sheet.
  static Future<void> show(
    BuildContext context, {
    String title = 'Sign in to book this court',
    String subtitle =
        'Please log in or create an account to reserve your spot.',
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LoginToBookDialog(title: title, subtitle: subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: kBorderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Close button row
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kCardColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 20, color: kDarkTextColor),
              ),
            ),
          ).withPaddingSymmetric(24, 0),

          16.heightBox,

          Divider(color: kCardColor, thickness: 5),
          16.heightBox,

          Text(
            title,
            style: AppStyles.w600f18inter.copyWith(
              color: kDarkTextColor,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ).withPaddingSymmetric(24, 0),

          12.heightBox,

          Text(
            subtitle,
            style: AppStyles.w400f16inter.copyWith(
              color: kDarkTextColor,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ).withPaddingSymmetric(24, 0),

          18.heightBox,
          Divider(color: kCardColor, thickness: 5),
          18.heightBox,

          // Buttons row
          Row(
            children: [
              // Sign In — dark button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RouteName.signIn);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkTextColor,
                    foregroundColor: kWhiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Sign In',
                    style: AppStyles.w600f16inter.copyWith(color: kWhiteColor),
                  ),
                ),
              ),

              16.widthBox,

              // Signup — primary yellow-green button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RouteName.signUp);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: kDarkTextColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Signup',
                    style: AppStyles.w600f16inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ).withPaddingSymmetric(24, 0),
        ],
      ),
    );
  }
}
