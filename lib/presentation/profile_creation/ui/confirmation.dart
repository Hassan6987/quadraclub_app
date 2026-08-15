import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/widgets/profile_summary_card.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/widgets/sports_cartegory_card.dart';
import 'package:quadraclub_app/utils/components/common_success_check.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CommonSuccessCheck(),
              20.heightBox,
              Text(
                "Everything's ready , Sami!",
                style: AppStyles.w600f24inter.copyWith(fontSize: 20),
              ),
              5.heightBox,
              Text(
                'Time to find courts, players, and matches near you.',
                textAlign: TextAlign.center,
                style: AppStyles.w400f14inter.copyWith(
                  color: kTextSecondary.withValues(alpha: 0.60),
                ),
              ),

              32.heightBox,
              Row(
                spacing: getProportionateScreenWidth(8),
                children: [
                  Expanded(
                    child: SportCategoryCard(
                      title: 'Tennis',
                      subtitle: 'Category B',
                    ),
                  ),
                  Expanded(
                    child: SportCategoryCard(
                      title: 'Padel',
                      subtitle: "2nd Category",
                    ),
                  ),
                ],
              ),
              8.heightBox,
              Row(
                spacing: getProportionateScreenWidth(8),
                children: [
                  Expanded(
                    child: SportCategoryCard(
                      title: 'PickleBall',
                      subtitle: 'Advanced',
                    ),
                  ),
                  Expanded(
                    child: SportCategoryCard(
                      title: 'Beach Tennis',
                      subtitle: "Category C",
                    ),
                  ),
                ],
              ),

              Divider(color: kDividerColor).withPaddingSymmetric(0, 32),
              ProfileSummaryCard(
                location: "Model Town Punjab",
                gender: "Masculine",
                dominantHand: "Right",
                dateOfBirth: "20 may 2004",
                preferredSide: "Right (Forehand)",
              ),

              12.heightBox,

              CustomActionButton(
                buttonText: "Find sports courts near me",
                onTap: () {},
                buttonTextColor: kDarkTextColor,
              ),
            ],
          ).withPaddingSymmetric(24, 32),
        ),
      ),
    );
  }
}






