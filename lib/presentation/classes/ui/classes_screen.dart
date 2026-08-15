import 'package:quadraclub_app/presentation/classes/ui/class_details_screen.dart';
import 'package:quadraclub_app/presentation/classes/ui/widgets/filter_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/common/widgets/common_chip.dart';

import '/app_exports.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final List<SportType> _selectedSports = [];
  DateTime _selectedDate = DateTime(2025, 4, 1);
  final TextEditingController _searchController = TextEditingController();
final String _searchQuery = '';

  List<DateTime> get _dates =>
      List.generate(7, (i) => DateTime(2025, 4, 1).add(Duration(days: i)));

  List<ClassModel> get _filtered {
    return dummyClasses.where((c) {
      final matchesSport = _selectedSports.isEmpty || _selectedSports.contains(c.sport);
      final matchesSearch =
          _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.coach.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSport && matchesSearch;
    }).toList();
  }

  Map<String, List<ClassModel>> get _groupedClasses {


    const demoToday = 7;

    final result = <String, List<ClassModel>>{};
    for (final c in _filtered) {
      String label;
      if (c.date.day == demoToday && c.date.month == 4) {
        label = 'Today, ${c.date.day} Apr';
      } else if (c.date.day == demoToday + 1 && c.date.month == 4) {
        label = 'Tomorrow, ${c.date.day} Apr';
      } else {
        label = '${c.date.day} Apr';
      }
      result.putIfAbsent(label, () => []).add(c);
    }
    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedClasses;

    return Scaffold(
      backgroundColor: kCardColor,
      appBar: CustomAppBar(
        title: "Available Classes",
        centerTile: false,
        backgroundColor: kWhiteColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kWhiteColor,
              border: Border(bottom: BorderSide(color: kBorderColor)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 33,
                  child: ListView(
                    scrollDirection: Axis.horizontal,

                    children: [
                      for (final sport in SportType.values) ...[
                        CommonChip(
                          label: sport.label,
                          isSelected: _selectedSports.contains(sport),
                          onTap: () => setState(() {
                            if (_selectedSports.contains(sport)) {
                              _selectedSports.remove(sport);
                            } else {
                              _selectedSports.add(sport);
                            }
                          }),
                        ).paddingOnly(
                          right: sport.index == SportType.values.length - 1
                              ? 0
                              : 6,
                        ),
                      ],
                    ],
                  ),
                ).withPaddingSymmetric(16, 0),
                12.heightBox,
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _searchController,
                        hintText: "Search by name...",
                        borderRadius: 100,
                      ),
                    ),
                    8.widthBox,
                    GestureDetector(
                      onTap: () => FilterBottomSheet.show(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: kBorderColor),
                        ),
                        child: SvgPicture.asset(
                          Assets.svg.filterLines.path,
                        ).withPaddingAll(8),
                      ),
                    ),
                  ],
                ).withPaddingSymmetric(16, 0),
                12.heightBox,

                CommonDateSelectionRow(
                  dates: _dates,
                  selectedDate: _selectedDate,
                  onDateSelected: (d) => setState(() => _selectedDate = d),
                ),
                16.heightBox,
              ],
            ),
          ),

          Expanded(
            child: grouped.isEmpty
                ? Center(
                    child: Text(
                      'No classes found.',
                      style: AppStyles.w600f18inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      for (final entry in grouped.entries) ...[
                        _dateGroupHeader(label: entry.key),
                        for (final classModel in entry.value)
                          ClassCard(
                            classModel: classModel,
                            onTap: () => _openDetails(classModel),
                          ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _openDetails(ClassModel classModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClassDetailsScreen(classModel: classModel),
      ),
    );
  }
  Widget _dateGroupHeader({required String label}) {
    return Row(
      children: [
        SvgPicture.asset(Assets.svg.calendarBlank.path),
        4.widthBox,
        Text(
          label,
          style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
        ),
        6.widthBox,

        Expanded(child: Divider(color: kTextColor.withValues(alpha: 0.50))),
      ],
    ).withPaddingSymmetric(16, 12);
  }

}



