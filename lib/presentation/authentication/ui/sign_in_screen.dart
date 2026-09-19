import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/ui/otp_verifictaion.dart';
import 'package:quadraclub_app/presentation/matches/bloc/matches_bloc.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/components/language_toggle_button.dart'
    show LanguageToggleButton;

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
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.success) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.customBottomNavbar,
            (_) => false,
            arguments: {"index": 2},
          );
          context.read<AgendaBloc>().add(GetAllAgenda());
          context.read<MatchesBloc>().add(GetAllBookings());
        } else if (state.status == AuthStateStatus.unVerified) {
          context.showToast(
            state.error ?? l10n.somethingWentWrong,
            isError: true,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  OtpVerificationScreen(email: _emailController.text.trim()),
            ),
          );
        } else if (state.status == AuthStateStatus.failure) {
          context.showToast(
            state.error ?? l10n.somethingWentWrong,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.heightBox,
                          Align(
                            alignment: Alignment.centerRight,
                            child: const LanguageToggleButton(),
                          ),
                          50.heightBox,
                          Text(
                            l10n.signIn,
                            style: AppStyles.w500f24inter.copyWith(
                              color: kTextPrimaryColor,
                            ),
                          ),
                          8.heightBox,
                          Text(
                            l10n.enterYourCredentialsManageYourBookings,
                            style: AppStyles.w400f16inter.copyWith(
                              color: kTextSecondary.withValues(alpha: 0.60),
                            ),
                          ),
                          40.heightBox,
                          CustomTextField(
                            label: l10n.email,
                            controller: _emailController,
                            hintText: l10n.enterYourEmail,
                            prefixIcon: SvgPicture.asset(
                              Assets.svg.emailIcon.path,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                                ValidateForm.validateEmail(v, l10n),
                            onChanged: (_) => _updateButtonState(),
                          ),
                          12.heightBox,
                          CustomTextField(
                            label: l10n.password,
                            controller: _passwordController,
                            hintText: l10n.enterYourPassword,
                            obscureText: true,
                            prefixIcon: SvgPicture.asset(
                              Assets.svg.lockIcon.path,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                                ValidateForm.passwordValidator(v, l10n),
                            onChanged: (_) => _updateButtonState(),
                          ),
                          8.heightBox,
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteName.forgetPassword,
                                );
                              },
                              child: Text(
                                l10n.forgotPassword,
                                style: AppStyles.subtitleMedium.copyWith(
                                  color: kTextPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                          24.heightBox,
                          if (state.status == AuthStateStatus.loading)
                            Center(child: CustomLoadingView()),
                          if (state.status != AuthStateStatus.loading)
                            CustomActionButton(
                              buttonText: l10n.signIn,
                              onTap: _onContinue,
                              backgroundColor: kPrimaryColor,
                              buttonTextColor: kDarkTextColor,
                            ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.doNotHaveAnAccount,
                                  style: AppStyles.w400f14inter.copyWith(
                                    color: kTextSecondary.withValues(
                                      alpha: 0.70,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteName.signUp,
                                    );
                                  },
                                  child: Text(
                                    l10n.createAccount,
                                    style: AppStyles.w500f14inter.copyWith(
                                      color: kTextPrimaryColor,
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
              },
            ),
          ).withPaddingAll(24),
        );
      },
    );
  }
}
