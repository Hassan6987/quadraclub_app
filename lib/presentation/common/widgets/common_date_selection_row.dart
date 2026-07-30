
import 'package:quadraclub_app/app_exports.dart';

class CommonDateSelectionRow extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CommonDateSelectionRow({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(70),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: dates.length,
        separatorBuilder: (_, _) => 8.widthBox,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selectedDate);
          final dayName = dayNames[date.weekday - 1];
          final month = monthNames[date.month - 1];

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor : kWhiteColor,
                borderRadius: BorderRadius.circular(14),
                border: isSelected ? null : Border.all(color: kBorderColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: AppStyles.w400f10inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    '${date.day}',
                    style: AppStyles.w600f18inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    month,
                    style: AppStyles.w400f10inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                ],
              ).withPaddingSymmetric(16,0),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
