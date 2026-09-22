import '/app_exports.dart';

/// Time-of-day buckets shared by the Courts, Matches and Classes filters.
/// All three are multi-select and show the same `am`/`pm` ranges.
enum TimeOfDayFilter { morning, afternoon, night }

extension TimeOfDayFilterX on TimeOfDayFilter {
  String get slug => name;

  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case TimeOfDayFilter.morning:
        return l10n.morning;

      case TimeOfDayFilter.afternoon:
        return l10n.afternoon;

      case TimeOfDayFilter.night:
        return l10n.night;
    }
  }

  String range(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case TimeOfDayFilter.morning:
        return l10n.morningTime;

      case TimeOfDayFilter.afternoon:
        return l10n.afternoonTime;

      case TimeOfDayFilter.night:
        return l10n.nightTime;
    }
  }

  /// Morning 6-12, afternoon 12-18, night 18-6.
  bool containsHour(int hour) {
    switch (this) {
      case TimeOfDayFilter.morning:
        return hour >= 6 && hour < 12;

      case TimeOfDayFilter.afternoon:
        return hour >= 12 && hour < 18;

      case TimeOfDayFilter.night:
        return hour >= 18 || hour < 6;
    }
  }
}

TimeOfDayFilter? timeOfDayFilterFrom(String? value) {
  switch (value?.trim().toLowerCase()) {
    case 'morning':
      return TimeOfDayFilter.morning;

    case 'afternoon':
      return TimeOfDayFilter.afternoon;

    case 'night':
    case 'evening':
      return TimeOfDayFilter.night;

    default:
      return null;
  }
}

/// True when [hour] falls into any of [selected]; an empty selection
/// means "no time filter" and matches everything.
bool matchesSelectedTimes(Set<TimeOfDayFilter> selected, int? hour) {
  if (selected.isEmpty) return true;
  if (hour == null) return false;
  return selected.any((t) => t.containsHour(hour));
}

int? parseHour(String? time) {
  if (time == null || time.trim().isEmpty) return null;
  return int.tryParse(time.trim().split(':').first);
}

// ---------------------------------------------------------------------------
// LEVELS
// ---------------------------------------------------------------------------

/// The two groups a level belongs to. A selected level always names one of
/// them, even while the gender toggle is on "Misto".
enum LevelGroup { homem, mulher }

extension LevelGroupX on LevelGroup {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return this == LevelGroup.homem ? l10n.genderMen : l10n.genderWomen;
  }
}

/// The toggle above the level sections. [misto] is the default and imposes
/// no restriction, so both groups stay on screen.
enum GenderFilter { misto, homem, mulher }

extension GenderFilterX on GenderFilter {
  List<LevelGroup> get visibleGroups {
    switch (this) {
      case GenderFilter.misto:
        return LevelGroup.values;

      case GenderFilter.homem:
        return const [LevelGroup.homem];

      case GenderFilter.mulher:
        return const [LevelGroup.mulher];
    }
  }

  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case GenderFilter.misto:
        return l10n.genderMixed;

      case GenderFilter.homem:
        return l10n.genderMen;

      case GenderFilter.mulher:
        return l10n.genderWomen;
    }
  }
}

const String kLevelOpen = 'open';
const String kLevelIniciante = 'iniciante';
const String kLevelIntermediario = 'intermediario';
const String kLevelAvancado = 'avancado';

/// Each sport's real ladder as one sequence, top first: Open, then the
/// categorias, then Iniciante. Padel runs 1ª-8ª, tennis and beach tennis
/// run A-E, and pickleball has its own three tiers.
const Map<String, List<String>> kSportLevelLadders = {
  'padel': [
    kLevelOpen,
    'cat_1',
    'cat_2',
    'cat_3',
    'cat_4',
    'cat_5',
    'cat_6',
    'cat_7',
    'cat_8',
    kLevelIniciante,
  ],
  'tennis': [
    kLevelOpen,
    'cat_a',
    'cat_b',
    'cat_c',
    'cat_d',
    'cat_e',
    kLevelIniciante,
  ],
  'beach_tennis': [
    kLevelOpen,
    'cat_a',
    'cat_b',
    'cat_c',
    'cat_d',
    'cat_e',
    kLevelIniciante,
  ],
  'pickleball': [kLevelAvancado, kLevelIntermediario, kLevelIniciante],
};

List<String> levelsForSport(String sportSlug) =>
    kSportLevelLadders[sportSlug] ?? const [];

String localizedLevelName(BuildContext context, String levelKey) {
  final l10n = AppLocalizations.of(context)!;

  switch (levelKey) {
    case kLevelOpen:
      return l10n.levelOpen;

    case kLevelIniciante:
      return l10n.levelBeginner;

    case kLevelIntermediario:
      return l10n.levelIntermediate;

    case kLevelAvancado:
      return l10n.levelAdvanced;
  }

  if (!levelKey.startsWith('cat_')) return levelKey;

  final suffix = levelKey.substring(4);

  return int.tryParse(suffix) != null
      ? l10n.levelCategoryNumber(suffix)
      : l10n.levelCategoryLetter(suffix.toUpperCase());
}

/// One level the user picked, inside one sport and one group.
class SportLevel {
  final String sport;
  final LevelGroup group;
  final String level;

  const SportLevel({
    required this.sport,
    required this.group,
    required this.level,
  });

  @override
  bool operator ==(Object other) =>
      other is SportLevel &&
      other.sport == sport &&
      other.group == group &&
      other.level == level;

  @override
  int get hashCode => Object.hash(sport, group, level);

  @override
  String toString() => '$sport/${group.name}/$level';
}

String _withoutDiacritics(String value) {
  const replacements = {
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ã': 'a',
    'é': 'e',
    'ê': 'e',
    'í': 'i',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ú': 'u',
    'ç': 'c',
  };

  var result = value;

  replacements.forEach((from, to) => result = result.replaceAll(from, to));

  return result;
}

/// Maps whatever the API sends for a match category or a class level onto a
/// ladder key. Handles both languages' spellings ("Category 3", "3ª
/// Categoria", "Categoria B", "Iniciante", "Beginner") and bare values.
String? levelKeyFrom(String? value) {
  final normalized = _withoutDiacritics(
    (value ?? '').trim().toLowerCase(),
  ).replaceAll(RegExp(r'\s+'), ' ');

  if (normalized.isEmpty) return null;

  switch (normalized) {
    case 'open':
    case 'aberto':
      return kLevelOpen;

    case 'iniciante':
    case 'beginner':
      return kLevelIniciante;

    case 'intermediario':
    case 'intermediate':
      return kLevelIntermediario;

    case 'avancado':
    case 'advanced':
      return kLevelAvancado;
  }

  // What's left should be a categoria: drop the word and any ordinal
  // marker, leaving just the digit or letter that identifies it.
  final identifier = normalized
      .replaceAll(RegExp(r'categorias?|category|cat'), '')
      .replaceAll(RegExp(r'[^a-z0-9]'), '');

  if (RegExp(r'^[1-8]$').hasMatch(identifier)) return 'cat_$identifier';

  if (RegExp(r'^[a-e]$').hasMatch(identifier)) return 'cat_$identifier';

  return null;
}

/// True when the item's sport and level resolve to one of [selected]; an
/// empty selection means "all levels" and matches everything.
///
/// The group is not compared: matches and classes carry no gender today, so
/// the toggle narrows which levels can be picked rather than the results.
bool matchesSelectedLevels(
  Set<SportLevel> selected, {
  String? sport,
  String? level,
}) {
  if (selected.isEmpty) return true;

  final key = levelKeyFrom(level);

  if (key == null) return false;

  final slug = sportSlug(sport);

  return selected.any(
    (s) => s.level == key && (slug.isEmpty || s.sport == slug),
  );
}

/// Drops selections that the gender toggle no longer shows.
Set<SportLevel> levelsAllowedBy(
  Set<SportLevel> selected,
  GenderFilter gender,
) {
  final groups = gender.visibleGroups;

  return selected.where((s) => groups.contains(s.group)).toSet();
}
