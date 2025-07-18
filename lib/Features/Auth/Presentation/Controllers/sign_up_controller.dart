import 'package:task_wizard/Features/Auth/Presentation/AuthBloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_wizard/Features/Shared/Utils/connectivity.dart';

class SignUpController {
  
  
  bool checked = false;
  final email = TextEditingController();
  
  final phone = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  

  String? firstNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required.';
    }
    final nameRegExp = RegExp(r'\d');
    if (nameRegExp.hasMatch(value)) {
      return 'You cannot have digit in your name';
    }
    return null;
  }

  String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }
    final nameRegExp = RegExp(
      r'\D',
    ); // Assuming you want to validate phone numbers with digits
    if (nameRegExp.hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

  String? secondNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Second name is required.';
    }
    final nameRegExp = RegExp(r'\d');
    if (nameRegExp.hasMatch(value)) {
      return 'You cannot have digit in your name';
    }
    return null;
  }

  Future<void> validateAll(BuildContext context) async {
    if (await NetworkManager.instance.isConnected() == false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No internet connection')));
      return;
    }
    final formState = formKey.currentState;
    if (!checked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          elevation: 3,
          showCloseIcon: true,
          closeIconColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Agree and Read the terms and conditions',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.yellow,
        ),
      );
      return;
    }
    if (formState!.validate()) {
      
      context.read<AuthBloc>().add(
        RegisterUserEvent(
          
          email: email.text.trim(),
          userName: username.text.trim(),
          phoneNumber: phone.text.trim(),
          password: password.text.trim(),
        ),
      );
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    final emailRegExp = RegExp(r'^[\w.]+@(\w+\.)+\w{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    if (!RegExp('[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter.';
    }
    return null;
  }

  String? validateUserName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required.';
    }
    if (!RegExp('[A-Za-z]').hasMatch(value)) {
      return 'Username must contain at least one alphabet.';
    }
    return null;
  }
}
