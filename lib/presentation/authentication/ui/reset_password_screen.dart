import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/utils/components/custom_auth_app_bar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updateButtonState);
    _confirmPasswordController.removeListener(_updateButtonState);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final isMatch =
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;

    if (_isButtonEnabled != isMatch) {
      setState(() {
        _isButtonEnabled = isMatch;
      });
    }
  }

  void _onContinue() {
    if (_isButtonEnabled) {
      if (_formKey.currentState!.validate()) {
        context.read<AuthBloc>().add(
          ResetPassword(
            email: widget.email,
            otp: widget.otp,
            password: _passwordController.text.trim(),
          ),
        );
      }
    }
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.verified) {
          context.showToast("Password Changed Successfully");
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (state.status == AuthStateStatus.failure) {
          context.showToast(
            state.error ?? "Something went wrong",
            isError: true,
          );
        }
      },
      child: Scaffold(
        appBar: CustomAuthAppBar(showBackIcon: true),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                32.heightBox,
                Text(
                  "Set New Password",
                  style: AppStyles.w500f24inter.copyWith(
                    color: kTextPrimaryColor,
                  ),
                ),
                8.heightBox,
                Text(
                  "Set new password to secure your account.",
                  style: AppStyles.w400f16inter.copyWith(
                    color: kTextSecondary.withValues(alpha: 0.60),
                  ),
                ),
                40.heightBox,
                CustomTextField(
                  label: "Password",
                  controller: _passwordController,
                  hintText: "Enter new password",
                  prefixIcon: SvgPicture.asset(Assets.svg.lockIcon.path),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: ValidateForm.passwordValidator,
                ),
                12.heightBox,
                CustomTextField(
                  label: "Confirm Password",
                  controller: _confirmPasswordController,
                  hintText: "Confirm new password",
                  prefixIcon: SvgPicture.asset(Assets.svg.lockIcon.path),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: _confirmPasswordValidator,
                ),
                40.heightBox,
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.status == AuthStateStatus.loading) {
                      return Center(child: CustomLoadingView());
                    }
                    return CustomActionButton(
                      buttonText: "Done",
                      onTap: _onContinue,
                      isEnabled: true,
                      backgroundColor: kPrimaryColor,
                      buttonTextColor: kTextPrimaryColor,
                    );
                  },
                ),
              ],
            ),
          ).withPaddingAll(24),
        ),
      ),
    );
  }
}
