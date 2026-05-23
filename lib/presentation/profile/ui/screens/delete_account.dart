import 'dart:developer';

import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/ui/welcome_screen.dart';
import 'package:quadraclub_app/utils/components/blue_app_bar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlueAppBar(title: 'Delete Account', showBackArrow: true),
      body: Column(
        children: [
          20.heightBox,
          Text(
            'This will delete your account and you will need to create your account again.',
            style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
            textAlign: TextAlign.center,
          ),
          32.heightBox,
          CustomActionButton(
            buttonText: 'I understand, delete account',
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

  final List<String> deleteReasons = [
    "I no longer need the app.",
    "I want to delete this account and create a new one.",
    "Trouble using the app.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlueAppBar(title: 'Delete Account', showBackArrow: true),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStateStatus.unAuthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (route) => true,
            );

            context.showToast("Account Deleted Successfully");
          } else if (state.status == AuthStateStatus.failure) {
            context.showToast(
              state.error ?? "Something went wrong",
              isError: true,
            );
          }
        },
        child: Column(
          children: [
            20.heightBox,
            Text(
              "Please tell us why you're leaving",
              style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
              textAlign: TextAlign.center,
            ),
            32.heightBox,
            ...deleteReasons.map(
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
                    reason,
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
                  buttonText: 'Delete Account',
                  isEnabled: selectedReason != null,
                  onTap: () {
                    log('Selected reason: $selectedReason');
                    if (state.user != null && state.user!.id != null) {
                      context.read<AuthBloc>().add(
                        DeleteAccountEvent(id: state.user!.id!),
                      );
                    } else {
                      context.showToast("No User Id found", isError: true);
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
