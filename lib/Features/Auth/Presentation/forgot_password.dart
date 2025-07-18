import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';

import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';
import 'package:task_wizard/Features/Shared/widgets/input_field.dart';

import 'reset_password.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              'Forgot Password',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              'Don\'t Worry if you Forgot your Password, Just enter your email to verify account and set a new password!',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            const InputField(
              label: 'Email',
              prefix: Icon(Iconsax.direct_right),
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  HelpingFunctions.removeAllPrevPagesAndPush(
                    context,
                    ResetPassword(),
                  );
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
