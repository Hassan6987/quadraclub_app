import 'package:quadraclub_app/app_exports.dart';

class SportDropdown extends StatefulWidget {
  final String sportName;
  final String sportIcon;
  final String? selectedCategory;
  final List<String> categories;
  final Map<String, String>
  categoryDescriptions;
  final ValueChanged<String?> onCategoryChanged;

  const SportDropdown({
    super.key,
    required this.sportName,
    required this.selectedCategory,
    required this.categories,
    required this.categoryDescriptions,
    required this.onCategoryChanged,
    required this.sportIcon,
  });

  @override
  State<SportDropdown> createState() => _SportDropdownState();
}

class _SportDropdownState extends State<SportDropdown> {
  bool _isExpanded = false;
  String? _tooltipShownFor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(widget.sportIcon, height: 20, width: 20),
            Text(
              widget.sportName,
              style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
            ).withPaddingSymmetric(6, 0),

            SvgPicture.asset(Assets.svg.infoIcon.path),
          ],
        ),
        8.heightBox,

        // ── Dropdown header ──────────────────────────────────────────────
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
              vertical: getProportionateScreenHeight(14),
            ),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBorderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.selectedCategory ?? 'Select your category',
                    style: AppStyles.w400f14inter.copyWith(color: kDarkTextColor),
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF606060),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (_isExpanded) ...[
          6.heightBox,
          Container(
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kBorderColor),
            ),
            child: Column(
              children: widget.categories.map((category) {
                final isSelected = widget.selectedCategory == category;
                final description = widget.categoryDescriptions[category];
                final showTooltip = _tooltipShownFor == category;

                return GestureDetector(
                  onTap: () {
                    widget.onCategoryChanged(category);
                    setState(() => _isExpanded = false);
                  },
                  child: Container(
                    // subtle divider between rows (skip for first)
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: isSelected
                        ? Stack(
                            alignment: Alignment.topCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      category,
                                      style: AppStyles.w400f14inter
                                          .copyWith(color: kDarkTextColor),
                                    ),
                                    6.widthBox,
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _tooltipShownFor =
                                              _tooltipShownFor == category
                                              ? null
                                              : category;
                                        });
                                      },
                                      child:  SvgPicture.asset(Assets.svg.infoIcon.path),
                                    ),
                                  ],
                                ),
                              ),

                              if (showTooltip && description != null) ...[
                                Positioned(
                                  right:20,
                                  top: -10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kWhiteColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: kBorderColor,
                                        width: 0.5
                                      ),

                                    ),
                                    child: Text(
                                      description,
                                      style: AppStyles.w400f14inter.copyWith(
                                        color: const Color(0xFF606060),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          )
                        : Row(
                          children: [
                            Text(
                                category,
                                style: AppStyles.w400f14inter.copyWith(
                                  color: kTextPrimaryColor,
                                ),
                              ),
                            6.widthBox,
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _tooltipShownFor =
                                  _tooltipShownFor == category
                                      ? null
                                      : category;
                                });
                              },
                              child:  SvgPicture.asset(Assets.svg.infoIcon.path),
                            ),
                          ],
                        ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
