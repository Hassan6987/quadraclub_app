import 'package:quadraclub_app/app_exports.dart';

/// Full-screen widget shown in place of user-specific screens (Profile, Agenda)
/// when the current user is not authenticated.
class GuestLoginPrompt extends StatelessWidget {
  final String title;
  final String subtitle;

  const GuestLoginPrompt({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCardColor,
      appBar: CustomAppBar(title: title, centerTile: false),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar placeholder circle
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 56,
                  color: kPrimaryColor.withValues(alpha: 0.70),
                ),
              ),

              32.heightBox,

              Text(
                title,
                style: AppStyles.headingSemibold.copyWith(
                  color: kDarkTextColor,
                ),
                textAlign: TextAlign.center,
              ),

              12.heightBox,

              Text(
                subtitle,
                style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
                textAlign: TextAlign.center,
              ),

              36.heightBox,

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteName.signIn),
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
                    'Login',
                    style: AppStyles.w600f16inter.copyWith(color: kWhiteColor),
                  ),
                ),
              ),

              20.heightBox,

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppStyles.w400f14inter.copyWith(
                      color: kGreyTextColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, RouteName.signUp),
                    child: Text(
                      'Sign Up',
                      style: AppStyles.w600f14inter.copyWith(
                        color: kMatchDayGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
