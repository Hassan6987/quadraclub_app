import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/common/widgets/common_chip.dart';

class AgendaFilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const AgendaFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const filters = ['All', 'Courts', 'Games', 'Classes'];
    return Row(
      spacing: getProportionateScreenWidth(6),
      children: filters
          .map(
            (filter) => CommonChip(
              label: filter,
              isSelected: filter == selectedFilter,
              onTap: () => onSelected(filter),
            ),
          )
          .toList(),
    ).withPaddingSymmetric(16, 12);
  }
}
