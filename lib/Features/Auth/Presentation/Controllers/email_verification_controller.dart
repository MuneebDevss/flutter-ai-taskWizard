import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_wizard/Features/Auth/Presentation/AuthBloc/auth_bloc.dart';
import 'package:task_wizard/Features/Auth/Presentation/email_verified.dart';
import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';

class EmailVerificationController {
  Future<void> checkEmailVerification(BuildContext context) async {
    final user = HelpingFunctions.getCurrentUser();

    if (user != null) {
      // Navigate if email is verified
      await user.reload();
      final refreshedUser = HelpingFunctions.getCurrentUser();
      if (refreshedUser!.emailVerified) {
        HelpingFunctions.removeAllPrevPagesAndPush(context, EmailVerified());
      } else {
        HelpingFunctions.showRejectedStateSnackbar(
          context,
          'User authenticated but not verified yet',
        );
      }
    } else {
      HelpingFunctions.showRejectedStateSnackbar(
        context,
        'Email not verified Yet',
      );
    }
  }

  void reSend(BuildContext context) {
    context.read<AuthBloc>().add(EmailConfirmation());
    HelpingFunctions.showConfirmedStateSnackbar(
      context,
      'We have resent the Verification Email',
    );
  }
}
