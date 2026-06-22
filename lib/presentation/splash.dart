import '/app_exports.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNewBallGreen,
      body: Center(
        child: Container(
          width: 180,
          height: 180,
          alignment: Alignment.center,
          child: Image.asset(Assets.png.splashLogo.path, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
