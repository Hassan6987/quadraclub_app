import 'package:quadraclub_app/app_exports.dart';

class CustomLoadingView extends StatelessWidget {
  const CustomLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.discreteCircle(
      size: 50,
      color: kPrimaryColor,
      secondRingColor: kBlackColor,
      thirdRingColor: kWhiteColor,
    );
  }
}
