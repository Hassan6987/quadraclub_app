import 'package:quadraclub_app/data/storage_service.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/profile/data/profile_menu_model.dart';
import 'package:quadraclub_app/presentation/profile/ui/widgets/profile_header_sliver.dart';
import 'package:quadraclub_app/presentation/profile/ui/widgets/profile_menu_list_item.dart';
import 'package:quadraclub_app/utils/components/alert_dialogue.dart';
import 'package:quadraclub_app/utils/components/blue_app_bar.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

import '/app_exports.dart';
import '../../../di/locator.dart';

class ProfileScreen extends StatelessWidget {
  final StorageService storageService = locator.get<StorageService>();

  ProfileScreen({super.key});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Logout',
        rightButtonText: 'Yes',
        leftButtonText: 'Cancel',
        onButtonTap: () {
          Navigator.pop(context);
          storageService.removeToken();
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.signIn,
            (_) => false,
          );
        },
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to logout?',
              style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
              textAlign: TextAlign.center,
            ),
          ],
        ).withPaddingSymmetric(16, 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<ProfileMenuItem> menuItems = [
      ProfileMenuItem(
        icon: Assets.svgProfile,
        title: 'My Profile',
        color: kPrimaryColor,
        onTap: () {
          Navigator.pushNamed(context, RouteName.myProfileScreen);
        },
      ),
      ProfileMenuItem(
        icon: Assets.svgPrivacyPolicyIcon,
        title: 'Privacy Policy',
        color: kPrimaryColor,
        onTap: () {
          Navigator.pushNamed(context, RouteName.privacyPolicyScreen);
        },
      ),
      ProfileMenuItem(
        icon: Assets.svgTermsConditionIcon,
        title: 'Term & Conditions',
        color: kPrimaryColor,
        onTap: () {
          Navigator.pushNamed(context, RouteName.termsConditionScreen);
        },
      ),
      ProfileMenuItem(
        icon: Assets.svgLogoutIcon,
        title: 'Logout',
        color: kPrimaryColor,
        onTap: () {
          _handleLogout(context);
        },
      ),
      ProfileMenuItem(
        icon: Assets.svgDeleteIcon,
        title: 'Delete Account',
        color: kRedColor,
        onTap: () {
          Navigator.pushNamed(context, RouteName.deleteAccountScreen);
        },
      ),
    ];

    return Scaffold(
      appBar: BlueAppBar(title: 'Profile', showBackArrow: false, height: 100),
      body: Padding(
        padding: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ProfileHeader(user: state.user!);
                },
              ),
              8.heightBox,
              24.heightBox,
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return ProfileMenuListItem(item: item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
