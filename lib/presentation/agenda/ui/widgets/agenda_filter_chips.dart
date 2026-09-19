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
    final l10n = AppLocalizations.of(context)!;
    const filters = ['All', 'Courts', 'Games', 'Classes'];
    return Row(
      spacing: getProportionateScreenWidth(6),
      children: filters
          .map(
            (filter) => CommonChip(
              label: _filterLabel(l10n, filter),
              isSelected: filter == selectedFilter,
              onTap: () => onSelected(filter),
            ),
          )
          .toList(),
    ).withPaddingSymmetric(16, 12);
  }

  String _filterLabel(AppLocalizations l10n, String filter) {
    switch (filter) {
      case 'All':
        return l10n.all;
      case 'Courts':
        return l10n.courts;
      case 'Games':
        return l10n.games;
      case 'Classes':
        return l10n.classes;
      default:
        return filter;
    }
  }
}
