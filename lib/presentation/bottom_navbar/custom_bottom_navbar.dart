import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/athletes/ui/athletes_screen.dart';
import 'package:quadraclub_app/presentation/home/bloc/home_bloc.dart';
import 'package:quadraclub_app/presentation/team_roster/bloc/team_roster_bloc.dart';
import 'package:quadraclub_app/presentation/team_roster/ui/team_roster_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int index;

  const CustomBottomNavBar({super.key, this.index = 0});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late final ValueNotifier<int> selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = ValueNotifier<int>(widget.index);
    context.read<HomeBloc>().add(GetScannedAthletes());
    context.read<TeamRosterBloc>().add(FetchTeamRoster());
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(),
      AthletesScreen(),
      MyTeamRosterScreen(),
      ProfileScreen(),
    ];
    final labels = ["Home", "Athletes", "Team Roster", "Profile"];
    final icons = [
      Assets.svgHome,
      Assets.svgAthletes,
      Assets.svgRosterIcon,
      Assets.svgProfile,
    ];

    final iconsFilled = [
      Assets.svgHomeFill,
      Assets.svgAthletesFill,
      Assets.svgRosterFillIcon,
      Assets.svgProfileFill,
    ];

    return PopScope(
      canPop: false,
      child: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, index, _) {
          return Scaffold(
            body: screens[index],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: kWhiteColor.withAlpha(190),
                border: const Border(
                  top: BorderSide(color: Color(0x30000000), width: 0.33),
                ),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: index,
                onTap: (i) => selectedIndex.value = i,
                selectedLabelStyle: AppStyles.w400f14inter.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  color: const Color(0XFFFE9CC5),
                ),
                unselectedLabelStyle: AppStyles.w400f14inter.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  color: const Color(0XFF999999),
                ),
                selectedItemColor: kSecondary2Color,
                unselectedItemColor: const Color(0XFF999999),
                items: List.generate(icons.length, (i) {
                  final isSelected = i == index;
                  final color = isSelected
                      ? kSecondary2Color
                      : const Color(0xFFACBEC5);
                  return BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      isSelected ? iconsFilled[i] : icons[i],
                      height: getProportionateScreenHeight(25),
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                    label: labels[i],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
