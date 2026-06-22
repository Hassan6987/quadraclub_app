import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child:LayoutBuilder(builder: (context, constraints) {
        return  SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            32.heightBox,
            Text(
                "Sign In",
                style: AppStyles.w500f24inter.copyWith(
                    color:kTextPrimaryColor
                )
            ),
            8.heightBox,
            Text(
                "Enter your credentials to manage your bookings.",
                style: AppStyles.w400f16inter.copyWith(
                    color:kGreen37.withValues(alpha: 0.60)
                )
            ),
            40.heightBox,
            CustomTextField(
              label: "Email",
              controller: _emailController,
              hintText: "Enter your email",
              prefixIcon: SvgPicture.asset(Assets.svg.emailIcon.path),
              keyboardType: TextInputType.emailAddress,
              validator: ValidateForm.validateCoachEmail,
              onChanged: (_) => _updateButtonState(),
            ),
            12.heightBox,
            CustomTextField(
              label: "Password",
              controller: _passwordController,
              hintText: "Enter your password",
              prefixIcon: SvgPicture.asset(Assets.svg.lockIcon.path),
              keyboardType: TextInputType.emailAddress,
              validator: ValidateForm.passwordValidator,
              onChanged: (_) => _updateButtonState(),
            ),
            8.heightBox,
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.forgetPassword);
                },
                child: Text(
                  "Forgot Password?",
                  style: AppStyles.subtitleMedium.copyWith(
                    color: kTextPrimaryColor,
                  ),
                ),
              ),
            ),
            24.heightBox,
            CustomActionButton(
              buttonText: "Sign In",
              onTap: _onContinue,
              backgroundColor: kNewBallGreen,
              buttonTextColor: kDarkColor,
            ),
        
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppStyles.w400f14inter.copyWith(
                      color: kGreen37.withValues(alpha: 0.70),
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
                      "Create Account",
                      style: AppStyles.w500f14inter.copyWith(
                        color: kTextPrimaryColor
                      ),
                    ),
                  ),
                ],
              ),
            ),
            32.heightBox,
          ],
        ),
            ),
          ),
        );
          },)
        ).withPaddingAll(24,),
      ),
    );
  }
}
