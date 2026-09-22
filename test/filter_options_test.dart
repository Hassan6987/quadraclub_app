import 'package:flutter_test/flutter_test.dart';
import 'package:quadraclub_app/app_exports.dart';

void main() {
  group('time of day', () {
    test('buckets cover the clock without gaps or overlaps', () {
      for (var hour = 0; hour < 24; hour++) {
        final matching = TimeOfDayFilter.values
            .where((t) => t.containsHour(hour))
            .toList();

        expect(matching, hasLength(1), reason: 'hour $hour');
      }
    });

    test('night wraps past midnight', () {
      expect(TimeOfDayFilter.night.containsHour(23), isTrue);
      expect(TimeOfDayFilter.night.containsHour(2), isTrue);
      expect(TimeOfDayFilter.night.containsHour(12), isFalse);
    });

    test('an empty selection matches everything, a set is OR-ed', () {
      expect(matchesSelectedTimes(const {}, 3), isTrue);

      expect(
        matchesSelectedTimes({
          TimeOfDayFilter.morning,
          TimeOfDayFilter.night,
        }, 20),
        isTrue,
      );

      expect(
        matchesSelectedTimes({TimeOfDayFilter.morning}, 20),
        isFalse,
      );
    });

    test('parses the hour out of API times', () {
      expect(parseHour('08:30'), 8);
      expect(parseHour('19:00'), 19);
      expect(parseHour(''), isNull);
      expect(parseHour(null), isNull);
    });
  });

  group('level ladders', () {
    test('each sport runs Open through categorias to Iniciante', () {
      expect(levelsForSport('padel'), [
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
      ]);

      expect(levelsForSport('tennis'), [
        kLevelOpen,
        'cat_a',
        'cat_b',
        'cat_c',
        'cat_d',
        'cat_e',
        kLevelIniciante,
      ]);

      expect(levelsForSport('beach_tennis'), levelsForSport('tennis'));

      expect(levelsForSport('pickleball'), [
        kLevelAvancado,
        kLevelIntermediario,
        kLevelIniciante,
      ]);

      expect(levelsForSport('squash'), isEmpty);
    });

    test('every ladder entry round-trips through the parser', () {
      for (final levels in kSportLevelLadders.values) {
        for (final level in levels) {
          expect(levelKeyFrom(level), level, reason: level);
        }
      }
    });

    test('parses both languages and bare values', () {
      expect(levelKeyFrom('Open'), kLevelOpen);
      expect(levelKeyFrom('Iniciante'), kLevelIniciante);
      expect(levelKeyFrom('Beginner'), kLevelIniciante);
      expect(levelKeyFrom('Avançado'), kLevelAvancado);
      expect(levelKeyFrom('Intermediário'), kLevelIntermediario);

      expect(levelKeyFrom('Category 3'), 'cat_3');
      expect(levelKeyFrom('3ª Categoria'), 'cat_3');
      expect(levelKeyFrom('8'), 'cat_8');

      expect(levelKeyFrom('Categoria B'), 'cat_b');
      expect(levelKeyFrom('Category B'), 'cat_b');
      expect(levelKeyFrom('e'), 'cat_e');

      expect(levelKeyFrom(null), isNull);
      expect(levelKeyFrom(''), isNull);
      expect(levelKeyFrom('something else'), isNull);
    });
  });

  group('level selection', () {
    const padelOpen = SportLevel(
      sport: 'padel',
      group: LevelGroup.homem,
      level: kLevelOpen,
    );

    test('an empty selection means all levels', () {
      expect(
        matchesSelectedLevels(const {}, sport: 'Padel', level: 'anything'),
        isTrue,
      );
    });

    test('matches on sport and level together', () {
      expect(
        matchesSelectedLevels({padelOpen}, sport: 'Padel', level: 'Open'),
        isTrue,
      );

      // Right level, wrong sport.
      expect(
        matchesSelectedLevels({padelOpen}, sport: 'Tennis', level: 'Open'),
        isFalse,
      );

      // Right sport, wrong level.
      expect(
        matchesSelectedLevels(
          {padelOpen},
          sport: 'Padel',
          level: '2ª Categoria',
        ),
        isFalse,
      );

      // Unclassifiable values drop out once a level is picked.
      expect(
        matchesSelectedLevels({padelOpen}, sport: 'Padel', level: null),
        isFalse,
      );
    });

    test('the same level in either group matches the data', () {
      // Matches and classes carry no gender, so the group narrows the
      // picker rather than the results.
      const padelOpenMulher = SportLevel(
        sport: 'padel',
        group: LevelGroup.mulher,
        level: kLevelOpen,
      );

      expect(
        matchesSelectedLevels({padelOpenMulher}, sport: 'Padel', level: 'Open'),
        isTrue,
      );
    });
  });

  group('gender toggle', () {
    const homemLevel = SportLevel(
      sport: 'padel',
      group: LevelGroup.homem,
      level: kLevelOpen,
    );
    const mulherLevel = SportLevel(
      sport: 'padel',
      group: LevelGroup.mulher,
      level: 'cat_1',
    );

    test('misto shows both groups and keeps every selection', () {
      expect(GenderFilter.misto.visibleGroups, LevelGroup.values);

      expect(
        levelsAllowedBy({homemLevel, mulherLevel}, GenderFilter.misto),
        {homemLevel, mulherLevel},
      );
    });

    test('picking a group drops selections from the other', () {
      expect(GenderFilter.homem.visibleGroups, [LevelGroup.homem]);

      expect(levelsAllowedBy({homemLevel, mulherLevel}, GenderFilter.homem), {
        homemLevel,
      });

      expect(levelsAllowedBy({homemLevel, mulherLevel}, GenderFilter.mulher), {
        mulherLevel,
      });
    });
  });
}
