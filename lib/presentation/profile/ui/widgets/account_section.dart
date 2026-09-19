import 'package:quadraclub_app/utils/components/language_toggle_button.dart';

import '../../../../app_exports.dart';
import '../../../authentication/bloc/auth_bloc.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CommonCard(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteName.myAccount);
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    Assets.svg.profile.path,
                    colorFilter: ColorFilter.mode(
                      kDarkTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                8.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.myAccount,
                        style: AppStyles.w500f14inter.copyWith(
                          color: kDarkTextColor,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        l10n.manageYourAccountDetails,
                        style: AppStyles.w400f14inter.copyWith(
                          color: kGreyTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: kDarkTextColor.withValues(alpha: 0.40),
                ),
              ],
            ).withPaddingAll(16),
          ),
          Divider(color: kDividerColor),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.language, color: kDarkTextColor, size: 20),
              ),
              8.widthBox,
              Expanded(
                child: Text(
                  l10n.language,
                  style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
                ),
              ),
              const LanguageToggleButton(),
            ],
          ).withPaddingAll(16),
          Divider(color: kDividerColor),
          GestureDetector(
            onTap: () {
              context.read<AuthBloc>().add(const LogoutEvent());
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kRedColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    Assets.svg.logoutIcon.path,
                    colorFilter: ColorFilter.mode(kRedColor, BlendMode.srcIn),
                  ),
                ),
                8.widthBox,
                Text(
                  l10n.logout,
                  style: AppStyles.w500f14inter.copyWith(color: kRedColor),
                ),
              ],
            ).withPaddingAll(16),
          ),
        ],
      ),
    );
  }
}
