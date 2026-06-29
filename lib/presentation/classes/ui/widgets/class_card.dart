
import 'package:quadraclub_app/presentation/classes/ui/widgets/common_badge.dart';

import '/app_exports.dart';

class ClassCard extends StatelessWidget {
  final ClassModel classModel;
  final VoidCallback onTap;

  const ClassCard({super.key, required this.classModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: classModel.status == ClassStatus.full ? null : onTap,
      child: Opacity(
        opacity: classModel.status == ClassStatus.full ? 0.7 : 1,
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
                  SportBadge(sport: classModel.sport),
                  4.widthBox,
                  CommonBadge(label: 'Category ${classModel.categoryRange}'),
                  4.widthBox,
                  CommonBadge(
                    label: classModel.format == ClassFormat.group
                        ? 'Group'
                        : 'Individual',
                  ),

                  const Spacer(),
                  Text(
                    '\$${classModel.price.toStringAsFixed(0)}',
                    style: AppStyles.w600f14inter.copyWith(color: kBlueF1),
                  ),
                ],
              ),
              8.heightBox,
              Text(
                classModel.title,
                style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
              ),
              4.heightBox,

              // Time + location
              Text(
                '${classModel.timeStart}-${classModel.timeEnd}  •  ${classModel
                    .location}  •  ${classModel.distanceKm} km',
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
                    imageUrl: kTennisPlayer,
                  ),
                  10.widthBox,
                  Text(
                    'Coach ',
                    style: AppStyles.w400f14inter.copyWith(
                      color: kGreyTextColor,
                    ),
                  ),
                  Text(
                    classModel.coach.name,
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

