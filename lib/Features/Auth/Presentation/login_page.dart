import 'package:task_wizard/Features/Auth/Presentation/Controllers/login_controller.dart';
import 'package:task_wizard/Features/Auth/Presentation/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wizard/Features/Landing/Presentation/Screens/landing_page.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';
import 'package:task_wizard/Features/Shared/Constants/const_texts.dart';

import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';
import 'package:task_wizard/Features/Shared/widgets/input_field.dart';
import 'package:task_wizard/Features/Shared/widgets/other_auth_methods.dart';
import 'package:task_wizard/Features/Shared/widgets/password_field.dart';
import 'package:task_wizard/Features/Shared/widgets/section_divider.dart';
import 'AuthBloc/auth_bloc.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  final controller = LoginController();
  @override
  void dispose() {
    controller.email.dispose();
    controller.password.dispose();
    super.dispose(); // Always call this last
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: SingleChildScrollView(
          //header
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Sizes.appBarHeight),
                    Text(
                      AuthTextConstants.welcomeBack,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: Sizes.p4),
                    Text(
                      AuthTextConstants.discover,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: Sizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: InputField(
                        controller: controller.email,
                        validate: controller.validateEmail,
                        label: AuthTextConstants.email,
                        prefix: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),
                    SizedBox(
                      width: double.infinity,
                      child: PasswordField(
                        controller: controller.password,
                        validate: controller.validatePassword,
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: Sizes.p4),
                        Checkbox(
                          value: isChecked,
                          onChanged: (val) {
                            if (val != null) {
                              isChecked = val;
                            }
                            setState(() {});
                          },
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AuthTextConstants.rememberMe,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),

                              TextButton(
                                onPressed: () {
                                  HelpingFunctions.pushOnePage(
                                    context,
                                    ForgotPassword(),
                                  );
                                },
                                child: Text(
                                  AuthTextConstants.forgotPassword,
                                  style: Theme.of(context).textTheme.labelLarge!
                                      .copyWith(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.spaceBtwSections),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, AuthState state) {
                        if (state is Failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                        if (state is SignedIn) {
                          HelpingFunctions.removeAllPrevPagesAndPush(
                            context,
                            const LandingPage(),
                          );
                        }
                      },
                      builder: (BuildContext context, AuthState state) {
                        if (state is BannerLoading) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(
                                Sizes.borderRadiusMd,
                              ),
                            ),
                            width: double.infinity,
                            height: kToolbarHeight,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.signIn(context);
                            },
                            child: const Text(AuthTextConstants.signIn),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ),
                            ),
                        child: const Text(AuthTextConstants.createAccount),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.spaceBtwSections),
                const SectionDivider(
                  dividerText: AuthTextConstants.orSignInWith,
                ),
                //Footer
                const SizedBox(height: Sizes.spaceBtwSections),
                const OtherAuthMethods(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
