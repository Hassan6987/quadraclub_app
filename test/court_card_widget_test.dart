import 'package:flutter_test/flutter_test.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/common/widgets/slot_scroll_sync.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_card_widget.dart';

final _date = DateTime(2026, 4, 1);
const _dateKey = '2026-04-01';

Sport _sport(String name) => Sport(
  sportName: name,
  hourlyRate: 100,
  openTime: '08:00',
  closeTime: '22:00',
  minDuration: 60,
);

Padel _slot(String time, {String status = 'Available'}) =>
    Padel(startTime: time, endTime: time, status: status, type: 'single');

WeeklySlot _weekly({
  List<Padel> padel = const [],
  List<Padel> tennis = const [],
}) => WeeklySlot(
  tennis: tennis,
  padel: padel,
  pickleball: const [],
  beachTennis: const [],
);

Court _court({
  required String name,
  required List<String> sports,
  required WeeklySlot slots,
}) => Court(
  id: name,
  courtName: name,
  location: 'x',
  coordinates: null,
  courtPhoto: null,
  amenities: const [],
  sports: sports.map(_sport).toList(),
  weeklySlots: {_dateKey: slots},
);

Club _club(List<Court> courts) => Club(
  id: 'club',
  name: 'Riverside Sports Hub',
  description: null,
  photo: null,
  city: 'Santa Monica',
  state: 'CA',
  coordinates: null,
  sports: const [],
  amenities: const [],
  courts: courts,
);

Widget _host(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Builder(
    builder: (context) {
      ResponsiveConfig().init(context);
      return Scaffold(body: SingleChildScrollView(child: child));
    },
  ),
);

void main() {
  testWidgets('pools slots of every court into one row per sport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final club = _club([
      _court(
        name: 'Padel 1',
        sports: ['Padel'],
        slots: _weekly(padel: [_slot('08:00'), _slot('09:00')]),
      ),
      _court(
        name: 'Padel 2',
        sports: ['Padel'],
        // 09:00 duplicates court 1, 10:00 is new.
        slots: _weekly(padel: [_slot('09:00'), _slot('10:00')]),
      ),
      _court(
        name: 'Tennis 1',
        sports: ['Tennis'],
        slots: _weekly(tennis: [_slot('11:00')]),
      ),
    ]);

    final sync = SlotScrollSync();
    addTearDown(sync.dispose);

    await tester.pumpWidget(
      _host(
        CourtCardWidget(
          club: club,
          selectedDate: _date,
          scrollSync: sync,
          onTap: () {},
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(tester.takeException(), isNull);

    // One row per sport, not per court.
    expect(find.text('Padel'), findsOneWidget);
    expect(find.text('Tennis'), findsOneWidget);
    expect(find.text('Padel 1'), findsNothing);
    expect(find.text('Padel 2'), findsNothing);

    // Slots past the right edge of a row are built but clipped, so look
    // offstage too — this asserts the pooling, not how many pills fit.
    for (final time in ['08:00', '09:00', '10:00', '11:00']) {
      expect(find.text(time, skipOffstage: false), findsOneWidget);
    }
  });

  testWidgets('the sport selection hides rows for unselected sports', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final club = _club([
      _court(
        name: 'Padel 1',
        sports: ['Padel'],
        slots: _weekly(padel: [_slot('08:00')]),
      ),
      _court(
        name: 'Tennis 1',
        sports: ['Tennis'],
        slots: _weekly(tennis: [_slot('11:00')]),
      ),
    ]);

    final sync = SlotScrollSync();
    addTearDown(sync.dispose);

    await tester.pumpWidget(
      _host(
        CourtCardWidget(
          club: club,
          selectedDate: _date,
          scrollSync: sync,
          selectedSports: const {'tennis'},
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Tennis'), findsOneWidget);
    expect(find.text('11:00'), findsOneWidget);
    expect(find.text('Padel'), findsNothing);
    expect(find.text('08:00'), findsNothing);
  });

  testWidgets('tapping the card opens the club, tapping a slot books it', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final club = _club([
      _court(
        name: 'Padel 1',
        sports: ['Padel'],
        slots: _weekly(padel: [_slot('08:00')]),
      ),
    ]);

    var cardTaps = 0;
    String? bookedTime;

    final sync = SlotScrollSync();
    addTearDown(sync.dispose);

    await tester.pumpWidget(
      _host(
        CourtCardWidget(
          club: club,
          selectedDate: _date,
          scrollSync: sync,
          onTap: () => cardTaps++,
          onTimeSlotTap: (court, sport, time) => bookedTime = time,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));

    // Anywhere on the card body opens the club page.
    await tester.tap(find.text('Riverside Sports Hub'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(cardTaps, 1);
    expect(bookedTime, isNull);

    // A slot pill books instead, without also opening the club page.
    await tester.tap(find.text('08:00'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(bookedTime, '08:00');
    expect(cardTaps, 1);
  });

  testWidgets('slot rows of different cards scroll together', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final manySlots = List.generate(
      14,
      (i) => _slot('${(8 + i).toString().padLeft(2, '0')}:00'),
    );

    Club clubWithSlots(String name) => Club(
      id: name,
      name: name,
      description: null,
      photo: null,
      city: 'Santa Monica',
      state: 'CA',
      coordinates: null,
      sports: const [],
      amenities: const [],
      courts: [
        _court(
          name: '$name court',
          sports: ['Padel'],
          slots: _weekly(padel: manySlots),
        ),
      ],
    );

    final sync = SlotScrollSync();
    addTearDown(sync.dispose);

    await tester.pumpWidget(
      _host(
        Column(
          children: [
            for (final name in ['Club A', 'Club B'])
              CourtCardWidget(
                club: clubWithSlots(name),
                selectedDate: _date,
                scrollSync: sync,
              ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));

    final rows = find.byType(ListView);
    expect(rows, findsNWidgets(2));

    await tester.drag(rows.first, const Offset(-120, 0));
    await tester.pump(const Duration(milliseconds: 50));

    final first = tester.widget<ListView>(rows.first).controller!;
    final second = tester.widget<ListView>(rows.at(1)).controller!;

    expect(first.offset, greaterThan(0));
    expect(second.offset, closeTo(first.offset, 0.5));
  });
}
