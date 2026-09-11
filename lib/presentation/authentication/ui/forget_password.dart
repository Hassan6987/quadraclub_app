import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/ui/otp_verifictaion.dart';
import 'package:quadraclub_app/utils/components/custom_auth_app_bar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '/app_exports.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    _emailController.addListener(_updateButtonState);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _emailController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.trim().isNotEmpty;
    });
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      context.read<AuthBloc>().add(ForgotPassword(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.otpSent) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpVerificationScreen(
                email: _emailController.text.trim(),
                isReset: true,
              ),
            ),
          );
          context.showToast("An otp has been sent to your email");
        } else if (state.status == AuthStateStatus.failure) {
          context.showToast(
            state.error ?? "Something went wrong",
            isError: true,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAuthAppBar(showBackIcon: true),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  32.heightBox,
                  Text(
                    "Forgot Password",
                    style: AppStyles.w500f24inter.copyWith(
                      color: kTextPrimaryColor,
                    ),
                  ),
                  8.heightBox,
                  Text(
                    "Enter the email address associated with account and we'll send you a recovery code.",
                    style: AppStyles.w400f16inter.copyWith(
                      color: kTextSecondary.withValues(alpha: 0.60),
                    ),
                  ),
                  40.heightBox,
                  CustomTextField(
                    label: "Email",
                    controller: _emailController,
                    hintText: "Enter your email",
                    prefixIcon: SvgPicture.asset(Assets.svg.emailIcon.path),
                    keyboardType: TextInputType.emailAddress,
                    validator: ValidateForm.validateEmail,
                    onChanged: (_) => _updateButtonState(),
                  ),
                  24.heightBox,
                  if (state.status == AuthStateStatus.loading)
                    Center(child: CustomLoadingView()),
                  if (state.status != AuthStateStatus.loading)
                    CustomActionButton(
                      buttonText: "Send Code",
                      onTap: _onContinue,
                      backgroundColor: kPrimaryColor,
                      buttonTextColor: kDarkTextColor,
                    ),
                ],
              ),
            ).withPaddingAll(24),
          ),
        );
      },
    );
  }
}
