import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/booking_summary_sheet.dart';
import 'package:shimmer/shimmer.dart';

class CourtDetailScreen extends StatefulWidget {
  final Club club;

  const CourtDetailScreen({super.key, required this.club});

  @override
  State<CourtDetailScreen> createState() => _CourtDetailScreenState();
}

class _CourtDetailScreenState extends State<CourtDetailScreen> {
  String? _selectedSportName;
  late final DateTime _anchorDate;
  late DateTime _selectedDate;
  late List<DateTime> _dates;

  // ------------------------------------------------------------
  // Synchronized horizontal scroll controllers
  // ------------------------------------------------------------

  final Map<String, ScrollController> _courtScrollControllers = {};

  bool _isSyncingScroll = false;

  // ------------------------------------------------------------
  // Sports
  // ------------------------------------------------------------

  /// Unique sport names across every court in the club, in the casing
  /// the API sends them ("Tennis", "Padel", ...) so tab labels and
  /// weeklySlots look up without extra normalization.
  List<String> get _sportNames {
    final names = <String>{};

    for (final court in widget.club.courts) {
      for (final sport in court.sports) {
        if ((sport.sportName ?? '').isNotEmpty) {
          names.add(sport.sportName!);
        }
      }
    }

    return names.toList();
  }

  @override
  void initState() {
    super.initState();

    final names = _sportNames;

    _selectedSportName = names.isNotEmpty ? names.first : null;

    final now = DateTime.now();

    _anchorDate = DateTime(now.year, now.month, now.day);

    _selectedDate = _anchorDate;

    _dates = List.generate(7, (i) => _anchorDate.add(Duration(days: i)));

    context.read<CourtsBloc>().add(FetchAllUsers());
  }

  // ------------------------------------------------------------
  // Scroll synchronization
  // ------------------------------------------------------------

  ScrollController _getCourtScrollController(String key) {
    final existingController = _courtScrollControllers[key];

    if (existingController != null) {
      return existingController;
    }

    final controller = ScrollController();

    controller.addListener(() {
      _syncCourtScroll(controller);
    });

    _courtScrollControllers[key] = controller;

    return controller;
  }

  void _syncCourtScroll(ScrollController sourceController) {
    if (_isSyncingScroll) return;

    if (!sourceController.hasClients) return;

    _isSyncingScroll = true;

    try {
      final sourceOffset = sourceController.offset;

      for (final controller in _courtScrollControllers.values) {
        if (controller == sourceController) continue;

        if (!controller.hasClients) continue;

        final maxOffset = controller.position.maxScrollExtent;

        final targetOffset = sourceOffset.clamp(0.0, maxOffset);

        if ((controller.offset - targetOffset).abs() > 0.5) {
          controller.jumpTo(targetOffset);
        }
      }
    } finally {
      _isSyncingScroll = false;
    }
  }

  String _courtScrollKey(Court court, int index) {
    return '${court.courtName ?? 'court'}_$index';
  }

  // ------------------------------------------------------------
  // Date
  // ------------------------------------------------------------

  String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }

  // ------------------------------------------------------------
  // Location
  // ------------------------------------------------------------

  String get _locationLabel {
    final city = widget.club.city ?? '';
    final state = widget.club.state ?? '';

    if (city.isEmpty) return state;

    if (state.isEmpty) return city;

    return '$city, $state';
  }

  // ------------------------------------------------------------
  // Photo
  // ------------------------------------------------------------

  String get _photoUrl =>
      widget.club.photo is String ? widget.club.photo as String : '';

  // ------------------------------------------------------------
  // Matching courts
  // ------------------------------------------------------------

  /// Every physical court in the club that offers the currently
  /// selected sport — usually one, but the UI supports several.
  List<Court> get _matchingCourts {
    final sport = _selectedSportName;

    if (sport == null) return const [];

    return widget.club.courts.where((court) {
      return court.sports.any(
        (s) => (s.sportName ?? '').toLowerCase() == sport.toLowerCase(),
      );
    }).toList();
  }

  // ------------------------------------------------------------
  // Slots
  // ------------------------------------------------------------

  /// Slots for [court] on the selected date, for the selected sport.
  /// WeeklySlot only decodes "Tennis"/"Padel" keys today — any other
  /// sport returns no slots rather than guessing at real availability.
  List<Padel> _slotsFor(Court court) {
    final daySlots = court.weeklySlots[_dateKey(_selectedDate)];

    if (daySlots == null) return const [];

    final sport = (_selectedSportName ?? '').toLowerCase();

    switch (sport) {
      case 'tennis':
        return daySlots.tennis;

      case 'padel':
        return daySlots.padel;

      case 'pickleball':
        return daySlots.pickleball;

      case 'beach tennis':
      case 'beach_tennis':
        return daySlots.beachTennis;

      default:
        return const [];
    }
  }

  // ------------------------------------------------------------
  // Time slot tap
  // ------------------------------------------------------------

  void _onTimeSlotTap(Court court, Padel slot) {
    if (slot.status != 'Available') return;

    BookingSummarySheet.show(
      context,
      club: widget.club,
      date: _selectedDate,
      startTime: slot.startTime ?? '',
      sportName: _selectedSportName,
      court: court,
    );
  }

  // ------------------------------------------------------------
  // Dispose
  // ------------------------------------------------------------

  @override
  void dispose() {
    for (final controller in _courtScrollControllers.values) {
      controller.dispose();
    }

    _courtScrollControllers.clear();

    super.dispose();
  }

  // ------------------------------------------------------------
  // Build
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final sportNames = _sportNames;
    final matchingCourts = _matchingCourts;

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: kWhiteColor,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: kBorderColor),
                  ),
                  child: const Icon(Icons.arrow_back, color: kDarkTextColor),
                ),
              ),
            ),
            title: Text(
              'Club Details',
              style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: _photoUrl,
                height: 120,
                width: double.infinity,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return Image.asset(
                    Assets.png.clubLogo.path,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.club.name ?? '',
                    style: AppStyles.w600f16inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),

                  4.heightBox,

                  Text(
                    _locationLabel,
                    style: AppStyles.w400f14inter.copyWith(color: kTextColor),
                  ),

                  if ((widget.club.description ?? '').isNotEmpty) ...[
                    8.heightBox,

                    Text(
                      widget.club.description!,
                      style: AppStyles.w400f12inter.copyWith(color: kTextColor),
                    ),
                  ],

                  10.heightBox,

                  Divider(color: kBorderColor, thickness: 5),

                  10.heightBox,

                  Text(
                    'Available Time Slots',
                    style: AppStyles.w500f14inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),

                  12.heightBox,

                  if (sportNames.isEmpty)
                    Text(
                      'No sports information available for this club.',
                      style: AppStyles.w400f14inter.copyWith(color: kTextColor),
                    )
                  else ...[
                    // ------------------------------------------------
                    // Sport tabs
                    // ------------------------------------------------
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: sportNames.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final name = sportNames[index];

                          final isSelected = _selectedSportName == name;

                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedSportName = name),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? kPrimaryColor : kGreyColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  name,
                                  style: AppStyles.w400f14inter.copyWith(
                                    color: kDarkTextColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    12.heightBox,

                    // ------------------------------------------------
                    // Date selection
                    // ------------------------------------------------
                    CommonDateSelectionRow(
                      dates: _dates,
                      selectedDate: _selectedDate,
                      onDateSelected: (date) =>
                          setState(() => _selectedDate = date),
                    ),

                    10.heightBox,

                    Divider(color: kBorderColor, thickness: 5),

                    10.heightBox,

                    // ------------------------------------------------
                    // Courts
                    // ------------------------------------------------
                    if (matchingCourts.isEmpty)
                      Text(
                        'No courts offer this sport yet.',
                        style: AppStyles.w400f14inter.copyWith(
                          color: kTextColor,
                        ),
                      )
                    else
                      ...matchingCourts.asMap().entries.map((entry) {
                        final courtIndex = entry.key;

                        final court = entry.value;

                        final slots = _slotsFor(court);

                        // Each court has its own controller,
                          // but all controllers synchronize their
                          // horizontal offset.
                          final scrollController = _getCourtScrollController(
                            _courtScrollKey(court, courtIndex),
                          );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                court.courtName ?? '',
                                style: AppStyles.w600f14inter.copyWith(
                                  color: kDarkTextColor,
                                ),
                              ),

                              10.heightBox,

                              if (slots.isEmpty)
                                Text(
                                  'No slots published for this date.',
                                  style: AppStyles.w400f14inter.copyWith(
                                    color: kTextColor,
                                  ),
                                )
                              else
                                SingleChildScrollView(
                                  // ONLY CHANGE:
                                  // attach the controller.
                                  controller: scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0; i < slots.length; i += 2)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildTimeSlotChip(
                                                court,
                                                slots[i],
                                              ),

                                              if (i + 1 < slots.length) ...[
                                                  const SizedBox(height: 10),

                                                _buildTimeSlotChip(
                                                  court,
                                                  slots[i + 1],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Time slot chip
  // ------------------------------------------------------------

  Widget _buildTimeSlotChip(Court court, Padel slot) {
    final available = slot.status == 'Available';

    return GestureDetector(
      onTap: available ? () => _onTimeSlotTap(court, slot) : null,
      child: Opacity(
        opacity: available ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: kBorderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                slot.startTime ?? '',
                style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
              ),

              4.widthBox,

              if (available)
                const CircleAvatar(radius: 3, backgroundColor: kGreen06),
            ],
          ),
        ),
      ),
    );
  }
}
