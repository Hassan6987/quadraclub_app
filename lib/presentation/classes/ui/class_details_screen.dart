import 'package:intl/intl.dart';

import '/app_exports.dart';
import '../data/model/class_models.dart';

class ClassDetailsScreen extends StatelessWidget {
  final Class classModel;
  final double distanceKm;

  const ClassDetailsScreen({
    super.key,
    required this.classModel,
    required this.distanceKm,
  })@override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isValid =
        classModel.registrationDeadline?.isAfter(DateTime.now()) ?? false;

    final registrationDeadline = classModel.registrationDeadline;

    final registrationDate = registrationDeadline != null
        ? DateFormat(
            'd MMM, h:mm a',
            l10n.localeName,
          ).format(registrationDeadline)
        : '';

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: CustomAppBar(
        title: l10n.classDetails,
        showActions: false,
        showBackIcon: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoCard(classModel: classModel, distanceKm: distanceKm,),
            4.heightBox,

            if (registrationDeadline != null)
              Container(
                decoration: BoxDecoration(
                  color: kRedColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: kRedColor),
                    6.widthBox,
                    Expanded(
                      child: Text(
                        l10n.registrationUntil(registrationDate),
                        style: AppStyles.w400f14inter.copyWith(
                          color: kRedColor,
                        ),
                      ),
                    ),
                  ],
                ).withPaddingSymmetric(8, 6),
              ),

            Divider(color: kDividerColor).withPaddingSymmetric(0, 16),

            Text(
              l10n.description,
              style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
            ),
            2.heightBox,

            Text(
              classModel.className,
              style: AppStyles.w400f14inter.copyWith(color: kTextColor),
            ),
            16.heightBox,

            ParticipantsCard(classModel: classModel),

            40.heightBox,

            CustomActionButton(
              buttonText: isValid
                  ? (classModel.isFull ?? false)
                        ? l10n.classFull
                        : l10n.confirmLesson
                  : l10n.registrationClosed,
              isEnabled: isValid,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        PaymentForLessonScreen(
                          classModel: classModel, distanceKm: distanceKm,),
                  ),
                );
              },
            ),
          ],
        ).withPaddingSymmetric(20, 16),
      ),
    );
  }
}
