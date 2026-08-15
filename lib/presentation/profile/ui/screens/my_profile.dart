import 'dart:developer';

import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/utils/components/blue_app_bar.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlueAppBar(title: 'My Profile', showBackArrow: true, height: 100),
      body: Padding(
        padding: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state.user!;
            return Column(
              children: [
                30.heightBox,
                _buildProfileImage(user),
                20.heightBox,
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
                      decoration: BoxDecoration(
                        color: Color(0xFFF9F4E8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildProfileField(
                            'Full Name',
                            user.profile?.fullName ?? 'N/A',
                          ),
                          _buildProfileField('Email', user.email ?? 'N/A'),
                          _buildProfileField(
                            'College Name',
                            user.profile?.collegeName ?? 'N/A',
                          ),
                          if (user.profile?.links != null &&
                              user.profile!.links!.isNotEmpty)
                            ...user.profile!.links!.asMap().entries.map(
                              (entry) => _buildProfileLinkField(
                                'Link ${entry.key + 1}',
                                entry.value.url ?? 'N/A',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                16.heightBox,
                CustomActionButton(
                  buttonText: 'Edit',
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.editProfileScreen);
                  },
                  backgroundColor: kSecondaryColor,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileImage(UserModel user) {
    return CircleAvatar(
      radius: 40,
      backgroundImage: (user.profile != null && user.profile!.image != null)
          ? NetworkImage(user.profile!.image!)
          : null,
      child: user.profile?.image == null
          ? Icon(Icons.person, size: 40, color: Colors.grey[600])
          : null,
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
          ),
          Flexible(
            child: Text(
              value,
              style: AppStyles.bodyMedium.copyWith(color: kBlackColor),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileLinkField(String label, String url) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () async {
                try {
                  final Uri uri = Uri.parse(url);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } catch (e) {
                  log('Could not launch $url: $e');
                }
              },
              child: Text(
                url,
                style: AppStyles.bodyMedium.copyWith(
                  color: Color(0xFF0737AF),
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
