import 'dart:developer';

import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/utils/components/blue_app_bar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: BlueAppBar(title: l10n.deleteAccount, showBackArrow: true),
      body: Column(
        children: [
          20.heightBox,
          Text(
            l10n.deleteAccountWarning,
            style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
            textAlign: TextAlign.center,
          ),
          32.heightBox,
          CustomActionButton(
            buttonText: l10n.iUnderstandDeleteAccount,
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteName.confirmDeleteAccountScreen,
              );
            },
            backgroundColor: kErrorColor,
          ),
        ],
      ).withPaddingSymmetric(24, 0),
    );
  }
}

class ConfirmDeleteAccount extends StatefulWidget {
  const ConfirmDeleteAccount({super.key});

  @override
  State<ConfirmDeleteAccount> createState() => _ConfirmDeleteAccountState();
}

class _ConfirmDeleteAccountState extends State<ConfirmDeleteAccount> {
  String? selectedReason;

  static const _reasonKeys = [
    'no_longer_need',
    'create_new',
    'trouble',
  ];

  String _reasonLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'no_longer_need':
        return l10n.deleteReasonNoLongerNeed;
      case 'create_new':
        return l10n.deleteReasonCreateNew;
      case 'trouble':
        return l10n.deleteReasonTrouble;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: BlueAppBar(title: l10n.deleteAccount, showBackArrow: true),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStateStatus.unAuthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => true,
            );

            context.showToast(l10n.accountDeletedSuccessfully);
          } else if (state.status == AuthStateStatus.failure) {
            context.showToast(
              state.error ?? l10n.somethingWentWrong,
              isError: true,
            );
          }
        },
        child: Column(
          children: [
            20.heightBox,
            Text(
              l10n.pleaseTellUsWhyYoureLeaving,
              style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
              textAlign: TextAlign.center,
            ),
            32.heightBox,
            ..._reasonKeys.map(
              (reason) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedReason == reason
                        ? kPrimaryColor
                        : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF101828).withValues(alpha: 0.05),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: RadioListTile<String>(
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                    });
                  },
                  title: Text(
                    _reasonLabel(l10n, reason),
                    style: AppStyles.bodyRegular.copyWith(color: kTextColor),
                  ),
                  activeColor: kPrimaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state.status == AuthStateStatus.deleting) {
                  return Center(child: CustomLoadingView());
                }
                return CustomActionButton(
                  buttonText: l10n.deleteAccount,
                  isEnabled: selectedReason != null,
                  onTap: () {
                    log('Selected reason: $selectedReason');
                    if (state.user != null && state.user!.id != null) {
                      context.read<AuthBloc>().add(
                        DeleteAccountEvent(id: state.user!.id!),
                      );
                    } else {
                      context.showToast(l10n.noUserIdFound, isError: true);
                    }
                  },
                  backgroundColor: kErrorColor,
                );
              },
            ),
            20.heightBox,
          ],
        ),
      ).withPaddingSymmetric(24, 0),
    );
  }
}
