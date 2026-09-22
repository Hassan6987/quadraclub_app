import 'package:intl/intl.dart';
import 'package:quadraclub_app/app_exports.dart';

/// Horizontal date strip. Squares are sized so exactly
/// [_visibleSquares] of them fit across the viewport, whatever the
/// device width.
class CommonDateSelectionRow extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  /// Inset of the strip itself. Pass 0 when the row already sits inside a
  /// padded parent so the squares keep the same size everywhere.
  final double horizontalPadding;

  const CommonDateSelectionRow({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
    this.horizontalPadding = 16,
  });

  static const double _gap = 8;
  static const int _visibleSquares = 5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final squareWidth =
              (constraints.maxWidth -
                  (horizontalPadding * 2) -
                  (_gap * (_visibleSquares - 1))) /
              _visibleSquares;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: dates.length,
            separatorBuilder: (_, _) => const SizedBox(width: _gap),
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = _isSameDay(date, selectedDate);
              final locale = Localizations.localeOf(context).toString();
              final dayName = DateFormat.E(locale).format(date);
              final month = DateFormat.MMM(locale).format(date);

              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: Container(
                  width: squareWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryColor : kWhiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? null : Border.all(color: kBorderColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _label(dayName, AppStyles.w400f10inter),
                      const SizedBox(height: 2),
                      _label('${date.day}', AppStyles.w600f16inter),
                      const SizedBox(height: 2),
                      _label(month, AppStyles.w400f10inter),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// `height: 1` keeps every square the same size regardless of the font's
  /// natural line spacing, which is what lets 5 of them fit on screen.
  Widget _label(String text, TextStyle style) => FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      text,
      maxLines: 1,
      style: style.copyWith(color: kDarkTextColor, height: 1),
    ),
  );

  bool _isSameDay(DateTime a, DateTime? b) {
    if (b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
