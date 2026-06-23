import 'package:quadraclub_app/app_exports.dart';

class ProfileCreationProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProfileCreationProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalSteps,
        (index) => Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: index < currentStep
                  ? kPrimaryColor
                  :kCardColor,
            ),
          ),
        ),
      ),
    );
  }
}
