import '/app_exports.dart';
import '../data/model/class_models.dart';

class ClassDetailsScreen extends StatelessWidget {
  final Class classModel;

  const ClassDetailsScreen({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    bool isValid =
        classModel.registrationDeadline?.isAfter(DateTime.now()) ?? false;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: CustomAppBar(
        title: "Class Details",
        showActions: false,
        showBackIcon: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoCard(classModel: classModel),
            4.heightBox,

            Container(
              decoration: BoxDecoration(
                color: kRedColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: kRedColor),
                  6.widthBox,
                  Text(
                    'Registration until ${monthNames[classModel.registrationDeadline!.month - 1]} '
                    '${classModel.registrationDeadline?.day}th, '
                    '${classModel.registrationDeadline?.hour}:00 AM',
                    style: AppStyles.w400f14inter.copyWith(color: kRedColor),
                  ),
                ],
              ).withPaddingSymmetric(8, 6),
            ),
            Divider(color: kDividerColor).withPaddingSymmetric(0, 16),

            Text(
              'Description',
              style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
            ),
            2.heightBox,
            Text(
              classModel.className ?? '',
              style: AppStyles.w400f14inter.copyWith(color: kTextColor),
            ),
            16.heightBox,

            ParticipantsCard(classModel: classModel),
            40.heightBox,
            CustomActionButton(
              buttonText: isValid
                  ? (classModel.isFull ?? false)
                        ? 'Class Full'
                        : 'Confirm Lesson'
                  : 'Registration Closed',
              isEnabled: isValid,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        PaymentForLessonScreen(classModel: classModel),
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

