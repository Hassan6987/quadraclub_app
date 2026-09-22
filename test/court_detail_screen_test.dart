import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/data/storage_service.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/courts_repository.dart';
import 'package:quadraclub_app/presentation/home/data/courts_services.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/ui/court_detail_screen.dart';

Sport _sport(String name) => Sport(
  sportName: name,
  hourlyRate: 100,
  openTime: '08:00',
  closeTime: '22:00',
  minDuration: 60,
);

Padel _slot(String time, {String status = 'Available'}) =>
    Padel(startTime: time, endTime: time, status: status, type: 'single');

Club _club() => Club(
  id: 'club',
  name: 'Riverside Sports Hub',
  description: null,
  photo: null,
  city: 'Santa Monica',
  state: 'CA',
  coordinates: null,
  sports: const ['Padel'],
  amenities: const ['Shower', 'Parking', 'Indoor Court', 'Outdoor Court'],
  courts: [
    Court(
      id: 'block1',
      courtName: 'Block 1',
      location: 'x',
      coordinates: null,
      courtPhoto: null,
      amenities: const [],
      sports: [_sport('Padel')],
      weeklySlots: {
        _key(DateTime.now()): WeeklySlot(
          tennis: const [],
          padel: [
            _slot('08:00'),
            _slot('08:30'),
            _slot('10:00', status: 'Booked'),
          ],
          pickleball: const [],
          beachTennis: const [],
        ),
      },
    ),
  ],
);

String _key(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // GetStorage writes to the documents directory, which has no plugin in
    // a test binding — point it at the temp dir instead.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => Directory.systemTemp.createTempSync('qc_test').path,
        );

    await GetStorage.init();

    dotenv.loadFromString(
      envString: 'BASE_URL_DEBUG=http://localhost/\n'
          'BASE_URL_STAGING=http://localhost/\n'
          'BASE_URL_PROD=http://localhost/',
    );

    // The screen's bloc resolves these from the locator; the HTTP calls it
    // makes are stubbed out by the test binding.
    if (!locator.isRegistered<StorageService>()) {
      locator.registerSingleton<StorageService>(StorageService());
    }
    if (!locator.isRegistered<CourtsServices>()) {
      locator.registerSingleton<CourtsServices>(CourtsServices());
    }
    if (!locator.isRegistered<CourtsRepository>()) {
      locator.registerSingleton<CourtsRepository>(CourtsRepository());
    }
  });

  testWidgets('club details lays out below the app bar with amenities', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (_) => CourtsBloc(),
          child: Builder(
            builder: (context) {
              ResponsiveConfig().init(context);
              return CourtDetailScreen(club: _club(), distance: 4.0);
            },
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(tester.takeException(), isNull);

    // Amenities are rendered, which the old screen dropped entirely.
    for (final amenity in ['Shower', 'Parking', 'Indoor Court']) {
      expect(find.text(amenity, skipOffstage: false), findsOneWidget);
    }

    // The photo starts below the app bar instead of under the status bar.
    final appBarBottom = tester.getRect(find.byType(CustomAppBar)).bottom;
    final photoTop = tester.getRect(find.byType(Image).first).top;
    expect(photoTop, greaterThanOrEqualTo(appBarBottom));

    // Dividers run the full width of the screen.
    for (final divider in tester.widgetList<Divider>(find.byType(Divider))) {
      final rect = tester.getRect(find.byWidget(divider));
      expect(rect.left, 0);
      expect(rect.right, 375);
    }

    // The date strip lines up with the club name rather than sitting inset.
    final nameLeft = tester.getRect(find.text('Riverside Sports Hub')).left;
    final dateRowLeft = tester
        .getRect(find.byType(CommonDateSelectionRow))
        .left;
    expect(dateRowLeft, lessThanOrEqualTo(nameLeft));

    // Booked slots stay visible but unbookable.
    expect(find.text('10:00', skipOffstage: false), findsOneWidget);
  });
}
