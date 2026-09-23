import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '/app_exports.dart';

/// Lets the signed-in user change levels (and preferred side) the same way
/// as the signup "Define your level" step.
class EditSportsLevelScreen extends StatefulWidget {
  final UserModel user;

  const EditSportsLevelScreen({super.key, required this.user});

  @override
  State<EditSportsLevelScreen> createState() => _EditSportsLevelScreenState();
}

class _EditSportsLevelScreenState extends State<EditSportsLevelScreen> {
  static const _allSports = ['Padel', 'Tennis', 'Beach Tennis', 'Pickleball'];

  static const _sportIcons = {
    'Padel': Icons.sports_tennis_outlined,
    'Tennis': Icons.sports_tennis,
    'Beach Tennis': Icons.beach_access_outlined,
    'Pickleball': Icons.sports_baseball_outlined,
  };

  /// Display name → canonical English category (via [levelApiValue]).
  late final Map<String, String?> _categories;

  /// One preferred side shared across every sport (same as signup).
  String? _preferredSide;
  String? _openDropdownSport;

  @override
  void initState() {
    super.initState();

    _categories = {
      for (final sport in _allSports)
        sport: _canonicalCategory(
          widget.user.sportsInfo
              .where((s) => _canonicalSportName(s.sport) == sport)
              .map((s) => s.category)
              .firstOrNull,
        ),
    };

    _preferredSide =
        widget.user.sportsInfo
            .map((s) => s.preferredSide)
            .whereType<String>()
            .where((s) => s.isNotEmpty)
            .firstOrNull ??
        'Right';
  }

  String _canonicalSportName(String? sport) {
    switch (sportSlug(sport)) {
      case 'padel':
        return 'Padel';
      case 'tennis':
        return 'Tennis';
      case 'beach_tennis':
        return 'Beach Tennis';
      case 'pickleball':
        return 'Pickleball';
      default:
        return sport?.trim() ?? '';
    }
  }

  String? _canonicalCategory(String? category) {
    if (category == null || category.isEmpty) return null;
    final key = levelKeyFrom(category);
    return key == null ? category : levelApiValue(key);
  }

  /// At least one sport level + a shared preferred side.
  bool get _canSave =>
      _preferredSide != null &&
      _allSports.any(
        (s) => _categories[s] != null && _categories[s]!.isNotEmpty,
      );

  String _categoryLabel(String category) {
    final key = levelKeyFrom(category);
    return key == null ? category : localizedLevelName(context, key);
  }

  String _sideLabel(AppLocalizations l10n, String side) {
    switch (side) {
      case 'Left':
        return l10n.left;
      case 'Right':
        return l10n.right;
      case 'Both':
        return l10n.both;
      default:
        return side;
    }
  }

  void _save() {
    if (!_canSave) return;

    // Include every sport that has a level; same preferred side on all.
    final sportsInfo = _allSports
        .where((s) => _categories[s] != null && _categories[s]!.isNotEmpty)
        .map(
          (sport) => SportsInfo(
            sport: sport,
            category: _categories[sport],
            preferredSide: _preferredSide,
          ),
        )
        .toList();

    context.read<AuthBloc>().add(UpdateProfile(sportsInfo: sportsInfo));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          prev.status == AuthStateStatus.updating &&
          (curr.status == AuthStateStatus.success ||
              curr.status == AuthStateStatus.failure),
      listener: (context, state) {
        if (state.status == AuthStateStatus.success) {
          Navigator.pop(context);
        } else if (state.status == AuthStateStatus.failure) {
          context.showToast(
            state.error ?? l10n.somethingWentWrong,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        final saving = state.status == AuthStateStatus.updating;

        return Scaffold(
          backgroundColor: kWhiteColor,
          appBar: CustomAppBar(
            title: l10n.defineYourLevel,
            showBackIcon: true,
            showActions: false,
            titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.heightBox,
                Text(
                  l10n.selectCategoryForEachSport,
                  style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
                ),
                24.heightBox,
                for (final sport in _allSports) _sportCategoryField(sport, l10n),
                // One preferred side for every sport (shared).
                _preferredSideField(l10n),
                8.heightBox,
                if (saving)
                  const Center(child: CustomLoadingView())
                else
                  CustomActionButton(
                    buttonText: l10n.update,
                    onTap: _save,
                    isEnabled: _canSave,
                    backgroundColor: kPrimaryColor,
                    buttonTextColor: kBlackColor,
                    width: double.infinity,
                  ),
                24.heightBox,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sportCategoryField(String sport, AppLocalizations l10n) {
    final selected = _categories[sport];
    final isOpen = _openDropdownSport == sport;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _sportIcons[sport] ?? Icons.sports_outlined,
                size: 18,
                color: kTextColor,
              ),
              8.widthBox,
              Text(
                sport,
                style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
              ),
            ],
          ),
          8.heightBox,
          GestureDetector(
            onTap: () {
              setState(() => _openDropdownSport = isOpen ? null : sport);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: kBorderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selected == null
                        ? l10n.selectYourCategory
                        : _categoryLabel(selected),
                    style: AppStyles.subtitleRegular.copyWith(
                      color: selected == null ? kTextColor : kBlackColor,
                    ),
                  ),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Container(
              margin: const EdgeInsets.only(top: 4),
              constraints: const BoxConstraints(maxHeight: 260),
              decoration: BoxDecoration(
                border: Border.all(color: kBorderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: levelsForSport(sportSlug(sport)).map((levelKey) {
                    final value = levelApiValue(levelKey);
                    final isSelected = selected == value;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _categories[sport] = value;
                          _openDropdownSport = null;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isSelected ? kPrimaryColor : kWhiteColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          localizedLevelName(context, levelKey),
                          style: AppStyles.subtitleRegular.copyWith(
                            color: kBlackColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _preferredSideField(AppLocalizations l10n) {
    const sides = ['Left', 'Right', 'Both'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.preferredSide,
            style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
          ),
          12.heightBox,
          Row(
            children: sides.map((side) {
              final isSelected = _preferredSide == side;

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _preferredSide = side),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF3FBCB) : kWhiteColor,
                      border: Border.all(
                        color: isSelected ? kPrimaryColor : kBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _sideLabel(l10n, side),
                      textAlign: TextAlign.center,
                      style: AppStyles.subtitleMedium.copyWith(
                        color: kBlackColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
