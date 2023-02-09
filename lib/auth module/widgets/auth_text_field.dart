import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../constants.dart';
import '../views/auth_screen.dart';

enum TextFieldType { email, password, repeatPassword }

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    this.textFieldController,
    required this.textFieldType,
    this.formType,
    required this.validator,
  });
  final TextEditingController? textFieldController;
  final TextFieldType textFieldType;
  final FormType? formType;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textFieldController,
      keyboardType: textFieldType == TextFieldType.email
          ? TextInputType.emailAddress
          : null,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: textFieldType == TextFieldType.email ||
              (textFieldType == TextFieldType.password &&
                  formType == FormType.signup)
          ? TextInputAction.next
          : TextInputAction.done,
      obscureText: textFieldType == TextFieldType.password ||
              textFieldType == TextFieldType.repeatPassword
          ? true
          : false,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(16)),
        isCollapsed: false,
        isDense: false,
        contentPadding: const EdgeInsets.all(12),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          gapPadding: 4,
          borderSide: const BorderSide(
            width: 3,
            color: grayscaleOffBlack,
          ),
        ),
        floatingLabelStyle: TextStyle(
          color: grayscaleLabel,
          fontSize: 18.sp,
        ),
        labelText: textFieldType == TextFieldType.email
            ? 'Email'
            : textFieldType == TextFieldType.password
                ? 'Пароль'
                : 'Подтвердите пароль',
        filled: true,
        fillColor: grayscaleInput,
        prefixIcon: textFieldType == TextFieldType.email
            ? const Icon(
                FishyIcons.mail,
                color: grayscaleOffBlack,
              )
            : textFieldType == TextFieldType.password
                ? const Icon(
                    FishyIcons.password,
                    color: grayscaleOffBlack,
                  )
                : const Icon(
                    FishyIcons.passwordRepeat,
                    color: grayscaleOffBlack,
                  ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            16,
          ),
          borderSide: BorderSide.none,
        ),
        //hintStyle: TextStyle()
      ),
      validator: validator,
    );
  }
}
