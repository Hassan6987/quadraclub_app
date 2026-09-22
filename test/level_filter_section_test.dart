import 'package:flutter_test/flutter_test.dart';
import 'package:quadraclub_app/app_exports.dart';

/// Hosts the controlled section so taps actually move the state, the way the
/// filter sheets drive it.
class _Host extends StatefulWidget {
  final List<String> sports;

  const _Host({required this.sports});

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  GenderFilter gender = GenderFilter.misto;
  Set<SportLevel> levels = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          ResponsiveConfig().init(context);
          return Scaffold(
            body: SingleChildScrollView(
              child: LevelFilterSection(
                sports: widget.sports,
                gender: gender,
                selected: levels,
                onChanged: (g, l) => setState(() {
                  gender = g;
                  levels = l;
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<_HostState> _pump(WidgetTester tester, List<String> sports) async {
  tester.view.physicalSize = const Size(375, 3000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(_Host(sports: sports));
  await tester.pump();

  return tester.state<_HostState>(find.byType(_Host));
}

void main() {
  testWidgets('only one sport section is open at a time', (tester) async {
    await _pump(tester, ['padel', 'tennis']);

    // Collapsed to start: headers only, no levels.
    expect(find.text('Padel'), findsOneWidget);
    expect(find.text('Tennis'), findsOneWidget);
    expect(find.text('Category 8'), findsNothing);

    await tester.tap(find.text('Padel'));
    await tester.pump();

    // Padel's ladder is the long one, and it runs 1 through 8.
    expect(find.text('Category 8'), findsWidgets);
    expect(find.text('Category E'), findsNothing);

    await tester.tap(find.text('Tennis'));
    await tester.pump();

    // Opening tennis closed padel.
    expect(find.text('Category 8'), findsNothing);
    expect(find.text('Category E'), findsWidgets);

    // Tapping the open section's header closes it again.
    await tester.tap(find.text('Tennis'));
    await tester.pump();
    expect(find.text('Category E'), findsNothing);
  });

  testWidgets('each sport offers its own ladder', (tester) async {
    await _pump(tester, ['pickleball']);

    await tester.tap(find.text('Pickleball'));
    await tester.pump();

    // Pickleball has its own three tiers and no Open or categorias.
    for (final level in ['Advanced', 'Intermediate', 'Beginner']) {
      expect(find.text(level), findsWidgets);
    }
    expect(find.text('Open'), findsNothing);
    expect(find.text('Category 1'), findsNothing);
  });

  testWidgets('misto shows both groups, picking one restricts the list', (
    tester,
  ) async {
    final host = await _pump(tester, ['padel']);

    await tester.tap(find.text('Padel'));
    await tester.pump();

    // Under Misto both group headings are on screen, alongside the three
    // toggle chips at the top.
    expect(find.text('Men'), findsNWidgets(2));
    expect(find.text('Women'), findsNWidgets(2));
    expect(find.text('Open'), findsNWidgets(2));

    await tester.tap(find.text('Women').last);
    await tester.pump();

    await tester.tap(find.text('Mixed'));
    await tester.pump();

    expect(host.gender, GenderFilter.misto);
  });

  testWidgets('switching to one gender drops the other group\'s picks', (
    tester,
  ) async {
    final host = await _pump(tester, ['padel']);

    await tester.tap(find.text('Padel'));
    await tester.pump();

    // Pick "Open" in each group: the first is Men, the second Women.
    await tester.tap(find.text('Open').first);
    await tester.pump();
    await tester.tap(find.text('Open').last);
    await tester.pump();

    expect(host.levels, {
      const SportLevel(
        sport: 'padel',
        group: LevelGroup.homem,
        level: kLevelOpen,
      ),
      const SportLevel(
        sport: 'padel',
        group: LevelGroup.mulher,
        level: kLevelOpen,
      ),
    });

    // Restricting to Men removes the Women pick automatically.
    await tester.tap(find.text('Men').first);
    await tester.pump();

    expect(host.gender, GenderFilter.homem);
    expect(host.levels, {
      const SportLevel(
        sport: 'padel',
        group: LevelGroup.homem,
        level: kLevelOpen,
      ),
    });

    // And only that group's ladder is left on screen.
    expect(find.text('Women'), findsOneWidget); // the toggle chip only
    expect(find.text('Open'), findsOneWidget);
  });
}
