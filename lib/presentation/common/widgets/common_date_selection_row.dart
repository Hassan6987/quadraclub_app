import 'package:intl/intl.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

/// Horizontal date strip. Squares are sized so exactly
/// [_visibleSquares] of them fit across the viewport, whatever the
/// device width.
///
/// The strip navigates, it does not filter: tapping a day hands it to
/// [onDateSelected] (the screen scrolls its list to that day) and slides the
/// tapped square to the middle of the strip. Days with nothing to show are
/// greyed out and cannot be tapped.
class CommonDateSelectionRow extends StatefulWidget {
  final List<DateTime> dates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  /// `yyyy-MM-dd` keys of the days that actually have something to show.
  /// `null` leaves every day selectable (Courts page, where a day always has
  /// slots).
  final Set<String>? availableDateKeys;

  /// Inset of the strip itself. Pass 0 when the row already sits inside a
  /// padded parent so the squares keep the same size everywhere.
  final double horizontalPadding;

  const CommonDateSelectionRow({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
    this.availableDateKeys,
    this.horizontalPadding = 16,
  });

  static const double _gap = 8;
  static const int _visibleSquares = 5;

  @override
  State<CommonDateSelectionRow> createState() => _CommonDateSelectionRowState();
}

class _CommonDateSelectionRowState extends State<CommonDateSelectionRow> {
  final ScrollController _scrollController = ScrollController();
  // Last layout metrics, captured in build so didUpdateWidget can use them.
  double _squareWidth = 0;
  double _viewportWidth = 0;


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CommonDateSelectionRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    final changed = !_isSameDay(
      widget.selectedDate ?? DateTime(0),
      oldWidget.selectedDate,
    );
    if (!changed || widget.selectedDate == null) return;

    final index = widget.dates.indexWhere(
          (d) => _isSameDay(d, widget.selectedDate),
    );
    if (index == -1) return;

    // Wait for the frame so the controller has final extents.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _centerSquare(index, _squareWidth, _viewportWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final squareWidth =
              (constraints.maxWidth -
                  (widget.horizontalPadding * 2) -
                  (CommonDateSelectionRow._gap *
                      (CommonDateSelectionRow._visibleSquares - 1))) /
                  CommonDateSelectionRow._visibleSquares;

          _squareWidth = squareWidth;
          _viewportWidth = constraints.maxWidth;

          return ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            itemCount: widget.dates.length,
            separatorBuilder: (_, _) =>
            const SizedBox(width: CommonDateSelectionRow._gap),
            itemBuilder: (context, index) {
              final date = widget.dates[index];
              final isSelected = _isSameDay(date, widget.selectedDate);
              final isAvailable = _isAvailable(date);
              final locale = Localizations.localeOf(context).toString();
              final dayName = DateFormat.E(locale).format(date);
              final month = DateFormat.MMM(locale).format(date);

              return GestureDetector(
                // Centering now happens in didUpdateWidget, which also
                // covers taps, because onDateSelected changes selectedDate.
                onTap: isAvailable ? () => widget.onDateSelected(date) : null,
                child: Opacity(
                  opacity: isAvailable ? 1 : 0.5,
                  child: Container(
                    width: squareWidth,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryColor : kWhiteColor,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? null
                          : Border.all(color: kBorderColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _label(dayName, AppStyles.w400f10inter, isAvailable),
                        const SizedBox(height: 2),
                        _label(
                          '${date.day}',
                          AppStyles.w600f16inter,
                          isAvailable,
                        ),
                        const SizedBox(height: 2),
                        _label(month, AppStyles.w400f10inter, isAvailable),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Slides the tapped square to the middle of the strip without running past
  /// either end of the list.
  void _centerSquare(int index, double squareWidth, double viewportWidth) {
    if (!_scrollController.hasClients) return;

    final itemExtent = squareWidth + CommonDateSelectionRow._gap;
    final target =
        widget.horizontalPadding +
        (index * itemExtent) +
        (squareWidth / 2) -
        (viewportWidth / 2);

    _scrollController.animateTo(
      target.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  /// Days without content are not selectable — the strip only ever points at
  /// a day the list below can actually scroll to.
  bool _isAvailable(DateTime date) {
    final keys = widget.availableDateKeys;
    if (keys == null) return true;

    return keys.contains(dateKey(date));
  }

  /// `height: 1` keeps every square the same size regardless of the font's
  /// natural line spacing, which is what lets 5 of them fit on screen.
  Widget _label(String text, TextStyle style, bool isAvailable) => FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      text,
      maxLines: 1,
      style: style.copyWith(
        color: isAvailable ? kDarkTextColor : kGreyB8,
        height: 1,
      ),
    ),
  );

  bool _isSameDay(DateTime a, DateTime? b) {
    if (b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
