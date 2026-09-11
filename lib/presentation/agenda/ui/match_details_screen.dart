import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/actions_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/details_tab.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/invited_tab.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/requests_tab.dart';

class MatchDetailsScreen extends StatefulWidget {
  const MatchDetailsScreen({super.key});

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  MatchDetailsTab _selectedTab = MatchDetailsTab.details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Match Details",
        showBackIcon: true,
        showActions: false,
        showThreeDotActions: true,
        onThreeDotTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => const ActionsBottomSheet(),
          );
        },
      ),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: kWhiteColor,
      child: Row(
        children: MatchDetailsTab.values.map((tab) {
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

  String _tabLabel(MatchDetailsTab tab) => switch (tab) {
    MatchDetailsTab.details => 'Details',
    MatchDetailsTab.requests => 'Requests',
    MatchDetailsTab.invited => 'Invited',
  };

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
