import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/classes/ui/classes_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int index;

  const CustomBottomNavBar({super.key, this.index = 2});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late final ValueNotifier<int> selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = ValueNotifier<int>(widget.index);
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      ClassesScreen(),
      Center(child: Text('Matches')),
      Center(child: Text('Courts')),
      Center(child: Text('Agenda')),
      ProfileScreen(),
    ];
    final labels = ["Classes", "Matches", "Courts", "Agenda", "Profile"];
    final icons = [
      Assets.svg.classes.path,
      Assets.svg.matches.path,
      Assets.svg.courts.path,
      Assets.svg.agenda.path,
      Assets.svg.profile.path,
    ];

    return PopScope(
      canPop: false,
      child: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, index, _) {
          return Scaffold(
            body: screens[index],
            bottomNavigationBar: Container(
              height: 75,
              decoration: BoxDecoration(color: kCardColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(icons.length, (i) {
                  final isSelected = i == index;
                  final color = isSelected ? kPrimaryColor : kDarkTextColor;

                  return GestureDetector(
                    onTap: () => selectedIndex.value = i,
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / icons.length,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            icons[i],
                            height: getProportionateScreenHeight(25),
                            colorFilter:
                            ColorFilter.mode(color, BlendMode.srcIn),
                          ),
                          6.heightBox,
                          Text(
                            labels[i],
                            style: (isSelected
                                ? AppStyles.w500f12inter
                                : AppStyles.w400f12inter)
                                .copyWith(color: color),
                          ),
                        ],
                      ),
                    ),
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