import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:task_wizard/Features/Auth/Presentation/AuthBloc/auth_bloc.dart';
import 'package:task_wizard/Features/Auth/Presentation/Controllers/sign_up_controller.dart';
import 'package:task_wizard/Features/Auth/Presentation/email_verification.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';
import 'package:task_wizard/Features/Shared/Constants/const_texts.dart';

import 'package:task_wizard/Features/Shared/widgets/input_field.dart';
import 'package:task_wizard/Features/Shared/widgets/other_auth_methods.dart';
import 'package:task_wizard/Features/Shared/widgets/password_field.dart';
import 'package:task_wizard/Features/Shared/widgets/section_divider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final SignUpController myController = SignUpController();
  @override
  void dispose() {
    myController.email.dispose();

    myController.phone.dispose();
    myController.username.dispose();
    myController.password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
        child: SingleChildScrollView(
          child: Form(
            key: myController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Sizes.spaceBtwItems),
                Text(
                  AuthTextConstants.signUpTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: Sizes.spaceBtwItems),

                const SizedBox(height: Sizes.spaceBtwItems),
                SizedBox(
                  child: InputField(
                    controller: myController.username,
                    validate: myController.validateUserName,
                    label: 'Username',
                    prefix: const Icon(Iconsax.user_edit),
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                SizedBox(
                  child: InputField(
                    label: 'Email',
                    prefix: const Icon(Iconsax.direct),
                    validate: myController.validateEmail,
                    controller: myController.email,
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                SizedBox(
                  child: InputField(
                    validate: myController.phoneNumber,
                    controller: myController.phone,
                    label: 'Phone',
                    prefix: const Icon(Iconsax.call),
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                SizedBox(
                  child: PasswordField(
                    validate: myController.validatePassword,
                    controller: myController.password,
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: myController.checked,
                      onChanged: (val) {
                        if (val != null) {
                          myController.checked = val;
                        }
                        setState(() {});
                      },
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'I agree to ',
                        style: Theme.of(context).textTheme.labelLarge,
                        children: [
                          TextSpan(
                            text: 'Privacy Policy',
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge!.apply(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Terms of Use',
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge!.apply(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (BuildContext context, AuthState state) {
                    if (state is UserRegistered) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EmailVerifcation(email: state.email),
                        ),
                      );
                    }

                    if (state is Failure) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            elevation: 3,
                            showCloseIcon: true,
                            closeIconColor: Colors.white,
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              state.message,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is BannerLoading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () => myController.validateAll(context),
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : Text(
                                  'Create Account',
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .apply(color: Colors.white),
                                ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: Sizes.spaceBtwSections),
                const SectionDivider(dividerText: 'or Sign Up with'),
                const SizedBox(height: Sizes.spaceBtwSections),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [OtherAuthMethods()],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
