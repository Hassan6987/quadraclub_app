import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '/app_exports.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _emailController.dispose();
    _passwordController.removeListener(_updateButtonState);
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();
    final isMatch = password.isNotEmpty && email.isNotEmpty;
    if (_isButtonEnabled != isMatch) {
      setState(() {
        _isButtonEnabled = isMatch;
      });
    }
  }

  void _onContinue() {
    if (_isButtonEnabled) {
      if (_formKey.currentState!.validate()) {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        context.read<AuthBloc>().add(
          LoginEvent(email: email, password: password),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStateStatus.failure) {
            context.showToast(
              state.error ?? "something went wrong",
              isError: true,
            );
          } else if (state.status == AuthStateStatus.success) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => CustomBottomNavBar()),
              (_) => false,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                100.heightBox,
                Text(
                  "Sign In",
                  style: AppStyles.subtitleMedium.copyWith(
                      color: kBlackColor, fontSize: 24),
                ),
                8.heightBox,
                Text(
                  "Enter your credentials to manage your bookings.",
                  style: AppStyles.titleSemibold.copyWith(
                      color: kTextColor, fontWeight: FontWeight.w400),
                ),
                24.heightBox,
                CustomTextField(
                  label: "Email",
                  controller: _emailController,
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidateForm.validateCoachEmail,
                  onChanged: (_) => _updateButtonState(),
                ),
                16.heightBox,
                CustomTextField(
                  label: "Password",
                  controller: _passwordController,
                  hintText: "Enter your password",
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidateForm.passwordValidator,
                  onChanged: (_) => _updateButtonState(),
                ),
                8.heightBox,
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.forgetPassword);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: AppStyles.subtitleMedium.copyWith(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                40.heightBox,
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.status == AuthStateStatus.loading) {
                      return Center(child: CustomLoadingView());
                    }
                    return CustomActionButton(
                      buttonText: "Continue",
                      onTap: _onContinue,
                      isEnabled: _isButtonEnabled,
                      backgroundColor: kSecondaryColor,
                      buttonTextColor: kWhiteColor,
                    );
                  },
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppStyles.titleRegular.copyWith(
                            color: kBlackColor,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              RouteName.signUp,
                            );
                          },
                          child: Text(
                            "Signup",
                            style: AppStyles.titleSemibold.copyWith(
                              color: kSecondaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: kSecondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
