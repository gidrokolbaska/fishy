import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../constants.dart';
import '../views/auth_screen.dart';

enum TextFieldType { email, password, repeatPassword }

class AuthTextField extends StatefulWidget {
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
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool showPrimaryPassword = false;
  bool showSecondaryPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textFieldController,
      keyboardType: widget.textFieldType == TextFieldType.email
          ? TextInputType.emailAddress
          : null,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: widget.textFieldType == TextFieldType.email ||
              (widget.textFieldType == TextFieldType.password &&
                  widget.formType == FormType.signup)
          ? TextInputAction.next
          : TextInputAction.done,
      obscureText: widget.textFieldType == TextFieldType.password
          ? showPrimaryPassword
              ? false
              : true
          : widget.textFieldType == TextFieldType.repeatPassword
              ? showSecondaryPassword
                  ? false
                  : true
              : false,

      // widget.textFieldType == TextFieldType.password ||
      //         widget.textFieldType == TextFieldType.repeatPassword
      //     ? showPrimaryPassword || showSecondaryPassword
      //         ? true
      //         : false
      //     : false,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        errorMaxLines: 2,
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
        suffixIcon: widget.textFieldType == TextFieldType.password ||
                widget.textFieldType == TextFieldType.repeatPassword
            ? IconButton(
                icon: const Icon(
                  FishyIcons.view,
                ),
                onPressed: () {
                  if (widget.textFieldType == TextFieldType.password) {
                    setState(() {
                      showPrimaryPassword = !showPrimaryPassword;
                    });
                  } else {
                    setState(() {
                      showSecondaryPassword = !showSecondaryPassword;
                    });
                  }
                },
              )
            : null,

        floatingLabelStyle: TextStyle(
          color: grayscaleLabel,
          fontSize: 18.sp,
        ),
        labelText: widget.textFieldType == TextFieldType.email
            ? 'Email'
            : widget.textFieldType == TextFieldType.password
                ? 'Пароль'
                : 'Подтвердите пароль',
        filled: true,
        fillColor: grayscaleInput,
        prefixIcon: widget.textFieldType == TextFieldType.email
            ? const Icon(
                FishyIcons.mail,
                color: grayscaleOffBlack,
              )
            : widget.textFieldType == TextFieldType.password
                ? const Icon(
                    FishyIcons.password,
                    color: grayscaleOffBlack,
                  )
                : const Icon(
                    FishyIcons.password_repeat,
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
      validator: widget.validator,
    );
  }
}
