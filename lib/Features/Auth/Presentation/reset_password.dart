import 'package:flutter/material.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';
import 'package:task_wizard/Features/Shared/Constants/const_texts.dart';
import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';


import 'login_page.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return     Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AuthTextConstants.emailVerifies,width: 200,height: 200,),
            const SizedBox(height: Sizes.spaceBtwItems,),
            Text('Password Reset Email sent',style: Theme.of(context).textTheme.headlineSmall,textAlign: TextAlign.center,),
            const SizedBox(height: Sizes.spaceBtwItems,),
            Text('Your Security is our Priority! We have sent You an email to securely change Your password and Keep Your account Protected.',style: Theme.of(context).textTheme.bodySmall,textAlign: TextAlign.center,),
            const SizedBox(height: Sizes.spaceBtwSections,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ()=>HelpingFunctions.removeAllPrevPagesAndPush(context, const LoginPage()),child:
              Text('Done',style: Theme.of(context).textTheme.bodyLarge!.apply(
                  color: Colors.white
              ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
