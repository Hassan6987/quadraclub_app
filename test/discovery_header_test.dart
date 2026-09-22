import 'package:flutter_test/flutter_test.dart';
import 'package:quadraclub_app/app_exports.dart';

void main() {
  test('sportSlug normalizes every spelling the API sends', () {
    expect(sportSlug('Padel'), 'padel');
    expect(sportSlug('Beach Tennis'), 'beach_tennis');
    expect(sportSlug('beach_tennis'), 'beach_tennis');
    expect(sportSlug('Pickleball'), 'pickleball');
    expect(sportSlug(null), '');
    for (final slug in kAllSportSlugs) {
      expect(sportSlug(slug), slug);
    }
  });

  Widget host(Widget child) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) {
        ResponsiveConfig().init(context);
        return Scaffold(
          appBar: const CustomAppBar(title: 'Find courts near you.'),
          body: Column(children: [child, const Expanded(child: SizedBox())]),
        );
      },
    ),
  );

  testWidgets('header lays out without overflow and fits 5 date squares', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final anchor = DateTime(2026, 4, 1);

    await tester.pumpWidget(
      host(
        DiscoveryHeader(
          selectedSports: const {'padel', 'tennis'},
          onSportToggled: (_) {},
          searchController: TextEditingController(),
          searchHint: 'Search by name...',
          onSearchChanged: (_) {},
          onFilterTap: () {},
          onMapTap: () {},
          dates: List.generate(14, (i) => anchor.add(Duration(days: i))),
          selectedDate: anchor,
          onDateSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    // All four sport pills are visible at once (the row never scrolls).
    expect(find.text('Padel'), findsOneWidget);
    expect(find.text('Tennis'), findsOneWidget);
    expect(find.text('Beach Tennis'), findsOneWidget);
    expect(find.text('Pickleball'), findsOneWidget);

    // Two weeks of dates, five of them on screen.
    final visibleDays = <int>[];
    for (var day = 1; day <= 14; day++) {
      final finder = find.text('$day');
      if (finder.evaluate().isEmpty) continue;
      final box = tester.getRect(finder);
      if (box.left >= 0 && box.right <= 375) visibleDays.add(day);
    }
    expect(visibleDays.length, 5);

    // Header is meaningfully shorter than the old per-screen ones (~195-210px).
    final headerHeight = tester.getSize(find.byType(DiscoveryHeader)).height;
    expect(headerHeight, lessThan(170));
  });
}
