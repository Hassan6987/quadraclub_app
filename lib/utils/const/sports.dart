import '/app_exports.dart';

/// The 4 sport types the filter row always shows, regardless of what
/// happens to be present in the currently loaded data.
const List<String> kAllSportSlugs = [
  'padel',
  'tennis',
  'beach_tennis',
  'pickleball',
];

/// Sports the user has in their profile sports-info.
///
/// Falls back to every sport when the profile has none (e.g. guest / empty
/// profile) so the filter never starts blank.
Set<String> defaultSelectedSportSlugs(Iterable<String?> sportNames) {
  final slugs = <String>{};
  for (final name in sportNames) {
    final slug = sportSlug(name);
    if (kAllSportSlugs.contains(slug)) slugs.add(slug);
  }
  return slugs.isEmpty ? kAllSportSlugs.toSet() : slugs;
}

/// Toggle [sport] in [selected].
///
/// The set is never left empty: deselecting the last selected sport
/// re-selects every sport (all pills green).
void toggleSportSelection(Set<String> selected, String sport) {
  if (selected.contains(sport)) {
    selected.remove(sport);
    if (selected.isEmpty) {
      selected.addAll(kAllSportSlugs);
    }
  } else {
    selected.add(sport);
  }
}

/// Normalizes the many spellings the API sends ("Beach Tennis",
/// "beach_tennis", "Padel", ...) into one of [kAllSportSlugs] so filter
/// state can be compared with a plain string equality.
String sportSlug(String? sportName) {
  final normalized = sportName?.trim().toLowerCase() ?? '';

  switch (normalized) {
    case 'padel':
    case 'pedal':
      return 'padel';

    case 'tennis':
      return 'tennis';

    case 'beach tennis':
    case 'beach_tennis':
    case 'beachtennis':
      return 'beach_tennis';

    case 'pickleball':
      return 'pickleball';

    default:
      return normalized;
  }
}

String localizedSportName(BuildContext context, String? sportName) {
  final l10n = AppLocalizations.of(context)!;

  switch (sportSlug(sportName)) {
    case 'padel':
      return l10n.padel;

    case 'tennis':
      return l10n.tennis;

    case 'beach_tennis':
      return l10n.beachTennis;

    case 'pickleball':
      return l10n.pickleball;

    default:
      return sportName ?? '';
  }
}
