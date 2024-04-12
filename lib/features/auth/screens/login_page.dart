import 'package:flights/core/enums/enums.dart';
import 'package:flights/core/extensions/firebase.dart';
import 'package:flights/core/widgets/custom_progress.dart';
import 'package:flights/core/widgets/custom_snackbar.dart';
import 'package:flights/features/auth/providers/auth_state_provider.dart';
import 'package:flights/features/auth/screens/selecte_account_type_screen.dart';
import 'package:flights/features/auth/services/authentecation_service.dart';
import 'package:flights/features/flights/screens/company_flights_screen.dart';
import 'package:flights/main_pages/home_page.dart';
import 'package:flights/utils/r.dart';
import 'package:flights/widgets/custom_text_field.dart';
import 'package:flights/widgets/fade_in_out_widget/fade_in_out_widget.dart';
import 'package:flights/widgets/fade_in_out_widget/fade_in_out_widget_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FadeInOutWidgetController _fadeInOutWidgetController = FadeInOutWidgetController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // _fillFields();
    const hSpace = SizedBox(
      height: 24.0,
    );
    return Stack(
      children: [
        const Scaffold(),
        FadeInOutWidget(
          fadeInOutWidgetController: _fadeInOutWidgetController,
          slideEndingOffset: const Offset(0, 0.01),
          child: Scaffold(
            backgroundColor: R.primaryColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                        tag: const ValueKey('logo'),
                        child: RotationTransition(
                            turns: const AlwaysStoppedAnimation(50 / 360),
                            child: Icon(Icons.flight, color: R.secondaryColor, size: 100))),
                    hSpace,
                    hSpace,
                    hSpace,
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: Icon(
                        Icons.email,
                        color: R.secondaryColor,
                      ),
                      mainColor: R.secondaryColor,
                      secondaryColor: R.tertiaryColor,
                    ),
                    hSpace,
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'كلمة المرور',
                      prefixIcon: Icon(
                        Icons.password,
                        color: R.secondaryColor,
                      ),
                      mainColor: R.secondaryColor,
                      secondaryColor: R.tertiaryColor,
                      isTextObscure: true,
                    ),
                    hSpace,
                    _buildLoginButton(context),
                    hSpace,
                    _buildSignUpTextWidget
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Consumer<AuthSataProvider>(builder: (context, provider, child) {
      return provider.authState == AuthState.notSet
          ? FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: R.secondaryColor,
                minimumSize: const Size(
                  double.infinity,
                  50,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                if (_emailController.text.isEmpty ||
                    !_emailController.text.contains('@') ||
                    _passwordController.text.isEmpty) {
                  showErrorSnackBar(context, 'الرجاء التأكد من صحة البيانات المدخلة');
                  return;
                }

                var result = await FlutterFireAuthServices()
                    .signIn(email: _emailController.text, password: _passwordController.text, context: context);

                if (result != null) {
                  _fadeInOutWidgetController.hide();
                  if (context.userType == 'client') {
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(
                              // routeTransitionValue: animation,
                              ),
                        ),
                      ),
                    );
                  } else {
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          pageBuilder: (context, animation, secondaryAnimation) => const CompanyFlightScreen(
                              // routeTransitionValue: animation,
                              ),
                        ),
                      ),
                    );
                  }
                }
              },
              child: Text(
                "تسجيل دخول",
                style: TextStyle(color: R.primaryColor, fontWeight: FontWeight.bold),
              ),
            )
          : const CustomProgress();
    });
  }

  Widget get _buildSignUpTextWidget => RichText(
        text: TextSpan(
          text: "ليس لديك حساب ",
          style: TextStyle(color: R.tertiaryColor),
          children: [
            TextSpan(
              text: "انضم لنا",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushNamed(SelectAccountTypeScreen.routeName);
                  // Long Pressed.
                },
              style: TextStyle(
                color: R.secondaryColor,
              ),
            )
          ],
        ),
      );
}
