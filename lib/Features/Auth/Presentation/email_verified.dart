
import 'package:task_wizard/Features/Auth/Presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';
import 'package:task_wizard/Features/Shared/Constants/const_images.dart';
import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';


class EmailVerified extends StatelessWidget {
  const EmailVerified({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ConstantImage.emailVerified, width: 200, height: 200),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              'Your account Successfully Created!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              'Welcome to Your Ultimate Shopping Destination: Your account is created . Unleash the Joy of Ultimate Seamless online Shopping!',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => HelpingFunctions.removeAllPrevPagesAndPush(
                        context,
                        LoginPage(),
                      ),
                child: Text(
                  'Continue',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.apply(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
