import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/widgets/progress_indicator.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

class ProfileCreationAppBar extends StatelessWidget {
  final VoidCallback onBackPressed;
  final int currentStep;
  final int totalSteps;

  const ProfileCreationAppBar({
    super.key,
    required this.onBackPressed,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onBackPressed,
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: kTextPrimaryColor,
              ),
            ),
            12.widthBox,
            Text("Back",style: AppStyles.w500f16inter,),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: kBorderColor,)
              ),
              child: Text(
                'Step $currentStep/$totalSteps',
                style: AppStyles.w500f14inter.copyWith(
                  color: kTextPrimaryColor,
                ),
              ).withPaddingSymmetric(12, 6),
            ),

          ],
        ).withPaddingSymmetric(24,0),
        20.heightBox,
        ProfileCreationProgressIndicator(
          currentStep: currentStep,
          totalSteps: totalSteps,
        ),
      ],
    );
  }
}
