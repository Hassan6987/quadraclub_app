import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/actions_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/details_tab.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/invited_tab.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/requests_tab.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

class MatchDetailsScreen extends StatefulWidget {
  final MatchDetailsTab initialTab;

  const MatchDetailsScreen({
    super.key,
    this.initialTab = MatchDetailsTab.details,
  });

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  late MatchDetailsTab _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
          appBar: CustomAppBar(
            title: l10n.matchDetails,
            showBackIcon: true,
            showActions: false,
            showThreeDotActions: false,
            onThreeDotTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const ActionsBottomSheet(),
              );
            },
          ),
          body: BlocBuilder<AgendaBloc, AgendaState>(
            builder: (context, state) {
              if (state.status == AgendaStateStatus.fetching) {
                return  Center(child: CustomLoadingView());
              }
              final match = state.matchDetails;
              if (state.status != AgendaStateStatus.fetching && match == null) {
                return Center(child: Text(l10n.nothingHereYet));
              }
              return Column(
                children: [
                  _buildTabs(state.matchDetails!.isOwner ?? false),
                  Expanded(child: _buildTabContent()),
                ],
              );
            },
          ),
        );

  }

  Widget _buildTabs(bool isOwner) {
    final tabs = isOwner ? MatchDetailsTab.values : [MatchDetailsTab.details];

    // Join-request deep links open on Requests; if this viewer isn't the
    // owner that tab isn't available, so fall back to Details.
    if (!tabs.contains(_selectedTab)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedTab = MatchDetailsTab.details);
      });
    }

    return Container(
      color: kWhiteColor,
      child: Row(
        children: tabs.map((tab) {
          final selected = _selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 14,
                ),
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
                  _tabLabel(tab),
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
  }

  String _tabLabel(MatchDetailsTab tab) {
    final l10n = AppLocalizations.of(context)!;
    return switch (tab) {
      MatchDetailsTab.details => l10n.details,
      MatchDetailsTab.requests => l10n.requests,
      MatchDetailsTab.invited => l10n.invited,
    };
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case MatchDetailsTab.details:
        return DetailsTab();
      case MatchDetailsTab.requests:
        return RequestsTab();
      case MatchDetailsTab.invited:
        return InvitedTab();
    }
  }
}
