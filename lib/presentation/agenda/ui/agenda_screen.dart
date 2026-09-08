import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  AgendaStatus _status = AgendaStatus.confirmed;
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Show guest prompt when user is not logged in
        if (state.user == null) {
          return const GuestLoginPrompt(
            title: 'My Reservations',
            subtitle:
            'Sign in to view your reservations, games and lessons',
          );
        }

        final actionLabel = _status == AgendaStatus.confirmed
            ? 'Chat'
            : _status == AgendaStatus.pending
            ? 'Cancel request'
            : null;

        return Scaffold(
          backgroundColor: kCardColor,
          appBar: CustomAppBar(
            title: "My Reservations,\nGames and Lessons",
            centerTile: false,
            backgroundColor: kWhiteColor,
          ),
          body: Column(
            children: [
              _statusTabs(),
              Container(
                color: kWhiteColor,
                child: AgendaFilterChips(
                  selectedFilter: _filter,
                  onSelected: (filter) => setState(() => _filter = filter),
                ),
              ),
              Expanded(
                child: ListView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    // if (_status != AgendaStatus.pending && (_filter == 'All' || _filter == 'Courts'))
                    //   CourtBookingCard(imgUrl: dummyCourts.first.imageUrl, showActions: showActions).paddingOnly(bottom: 12),
                    if (_filter == 'All' || _filter == 'Games')
                      AgendaMatchCard(
                        match: agendaMatches.first,
                        actionLabel: actionLabel,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MatchDetailsScreen(
                                    match: agendaMatches.first,
                                  ),
                            ),
                          );
                        },
                      ).paddingOnly(bottom: 12),
                    if (_filter == 'All' || _filter == 'Classes')
                      AgendaClassCard(
                        item: agendaClasses.first,
                        actionLabel: actionLabel,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusTabs() => Container(
    color: kWhiteColor,
    child: Row(
      children: AgendaStatus.values.map((status) {
        final selected = _status == status;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _status = status),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? kBlueColor : kDividerColor,
                    width: selected ? 2 : 1,
                  ),
                ),
              ),
              child: Text(
                _statusLabel(status),
                style: AppStyles.w500f14inter.copyWith(
                  color: selected ? kDarkTextColor : kGreyTextColor,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );

  String _statusLabel(AgendaStatus status) => switch (status) {
    AgendaStatus.confirmed => 'Confirmed',
    AgendaStatus.pending => 'Pending',
    AgendaStatus.past => 'Past',
  };
}
