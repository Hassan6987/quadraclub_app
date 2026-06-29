
import 'package:quadraclub_app/app_exports.dart';

class DateSelector extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(70),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        padding: EdgeInsets.zero,
        separatorBuilder: (_, _) => 8.widthBox,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selectedDate);
          final dayName = _dayNames[date.weekday - 1];
          final month = _monthNames[date.month - 1];

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: getProportionateScreenWidth(65),
              height: getProportionateScreenHeight(65),
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

                  Text(
                    '${date.day}',
                    style: AppStyles.w600f18inter.copyWith(
                      color: kDarkTextColor,
                      fontSize: 14,
                    ),
                  ),

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
