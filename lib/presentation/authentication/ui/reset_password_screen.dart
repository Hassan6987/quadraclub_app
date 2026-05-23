import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/ui/widgets/auth_appbar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

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
            password: _passwordController.text,
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
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AuthAppBar(showBackButton: true),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStateStatus.verified) {
            context.showToast('Password Reset Successfully');
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteName.signIn,
              (route) => false,
            );
          } else if (state.status == AuthStateStatus.failure) {
            context.showToast(
              state.error ?? "something went wrong, try again",
              isError: true,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dim.PADDING_SIZE_LARGE,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create New Password",
                  style: AppStyles.headingSemibold.copyWith(color: kBlackColor),
                ),
                8.heightBox,
                Text(
                  "Create your new password",
                  style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
                ),
                32.heightBox,
                CustomTextField(
                  label: "Password",
                  controller: _passwordController,
                  hintText: "Enter new password",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: ValidateForm.passwordValidator,
                ),
                20.heightBox,
                CustomTextField(
                  label: "Confirm Password",
                  controller: _confirmPasswordController,
                  hintText: "Confirm new password",
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
                      buttonText: _isButtonEnabled ? "Done" : "Update",
                      onTap: _onContinue,
                      isEnabled: _isButtonEnabled,
                      backgroundColor: kSecondaryColor,
                      buttonTextColor: kWhiteColor,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
