import '/app_exports.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(flex: 4),
            Image.asset(Assets.pngSplashLogo, height: 100),
            20.heightBox,
            Text(
              'GetStarted',
              style: AppStyles.headingSemibold.copyWith(
                color: kPrimaryColor,
                fontSize: 40,
              ),
            ),
            Text(
              'Track Athletes By Scanning NFC Wristbands',
              style: AppStyles.titleMedium.copyWith(color: kTextColor),
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 6),
            CustomActionButton(
              buttonText: "Sign In",
              width: double.infinity,
              height: 52,
              borderRadius: 8,
              onTap: () {
                Navigator.pushNamed(context, RouteName.signIn);
              },
              isEnabled: true,
              backgroundColor: kSecondaryColor,
            ),
            10.heightBox,
            CustomActionButton(
              buttonText: "Sign Up",
              width: double.infinity,
              height: 52,
              borderRadius: 8,
              onTap: () {
                Navigator.pushNamed(context, RouteName.signUp);
              },
              isEnabled: true,
              backgroundColor: kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
