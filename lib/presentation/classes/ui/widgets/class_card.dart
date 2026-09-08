import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';

import '/app_exports.dart';

class ClassCard extends StatelessWidget {
  final Class classModel;
  final VoidCallback onTap;

  const ClassCard({super.key, required this.classModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (classModel.isFull ?? true) ? null : onTap,
      child: Opacity(
        opacity: (classModel.isFull ?? true) ? 0.3 : 1,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(12),
          ),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: kWhiteFo),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SportBadge(sport: SportTypeExtension.fromString(
                      classModel.sportName ?? '')),
                  4.widthBox,
                  CommonBadge(label: 'Category ${classModel.level}'),
                  4.widthBox,
                  CommonBadge(
                    label: classModel.format?.trim().toLowerCase() ==
                        ClassFormat.group.name.toLowerCase()
                        ? 'Group'
                        : 'Individual',
                  ),

                  const Spacer(),
                  Text(
                    '\$${classModel.price?.toStringAsFixed(0)}',
                    style: AppStyles.w600f14inter.copyWith(color: kBlueF1),
                  ),
                ],
              ),
              8.heightBox,
              Text(
                classModel.className ?? 'Unknown',
                style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
              ),
              4.heightBox,

              // Time + location
              Text(
                '${classModel.startTime}-${classModel.endTime}  •  ${classModel
                    .locationName}  •  ${classModel.distanceKm} km',
                style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
              ),
              8.heightBox,

              // Coach row
              Row(
                children: [
                  AppCachedImage(
                    borderRadius: BorderRadius.circular(100),
                    height: 36,
                    width: 36,
                    imageUrl: classModel.coachPhoto ?? '',
                  ),
                  10.widthBox,
                  Text(
                    'Coach ',
                    style: AppStyles.w400f14inter.copyWith(
                      color: kGreyTextColor,
                    ),
                  ),
                  Text(
                    classModel.coachName ?? '',
                    style: AppStyles.w500f14inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                ],
              ),
              Divider(color: kBorderColor).withPaddingSymmetric(0, 8),
              ParticipantsRow(classModel: classModel),
            ],
          ).withPaddingAll(12),
        ),
      ),
    );
  }

}


