import 'package:animations/animations.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/reusable%20widgets/green_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:sizer/sizer.dart';

import '../../providers/auth_provider.dart';
import '../../api/auth/authentication.dart';
import '../widgets/auth_text_field.dart';

enum FormType { signin, signup }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<AuthScreen> {
  late final Authentication auth = ref.watch(authProvider);
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final ValueNotifier<FormType> _formTypeNotifier =
      ValueNotifier<FormType>(FormType.signin);
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  void _switchType() {
    if (_formTypeNotifier.value == FormType.signup) {
      _formTypeNotifier.value = FormType.signin;
    } else {
      _formTypeNotifier.value = FormType.signup;
    }
  }

  Future<void> _authenticate(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formTypeNotifier.value == FormType.signin) {
      await auth.login(_emailTextController.text, _passwordTextController.text,
          context, ref);
    } else {
      await auth.signUp(_emailTextController.text, _passwordTextController.text,
          context, ref);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      persistentFooterButtons: [
        GreenButton(
          buttonSize: const Size(double.maxFinite, 56),
          buttonText: 'Войти',
          isLoading: _isLoading,
          onTap: () => _authenticate(context),
        ),
        const SizedBox(
          height: 10,
        ),
        GoogleAuthButton(
          isLoading: false,
          onPressed: () {},
          text: 'Войти с Google',
          style: const AuthButtonStyle(
            borderRadius: 32,
            width: double.maxFinite,
            height: 56,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        AppleAuthButton(
          onPressed: () {},
          text: 'Войти с Apple',
          style: const AuthButtonStyle(
            borderRadius: 32,
            height: 56,
            width: double.maxFinite,
          ),
        ),
      ],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                'assets/images/appIconSmall.png',
                alignment: Alignment.center,
                height: 15.h,
              ),
              SizedBox(
                height: 2.h,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      builder: (BuildContext context, value, Widget? child) {
                        return PageTransitionSwitcher(
                          duration: const Duration(milliseconds: 500),
                          reverse: _formTypeNotifier.value != FormType.signin,
                          layoutBuilder: (entries) {
                            return Stack(
                              alignment: Alignment.centerLeft,
                              children: entries,
                            );
                          },
                          transitionBuilder:
                              (child, primaryAnimation, secondaryAnimation) {
                            return SharedAxisTransition(
                              animation: primaryAnimation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType:
                                  SharedAxisTransitionType.horizontal,
                              child: child,
                            );
                          },
                          child: value == FormType.signin
                              ? Text(
                                  'Авторизация',
                                  key: const Key('a'),
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                )
                              : Text(
                                  'Регистрация',
                                  key: const Key('b'),
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                        );
                      },
                      valueListenable: _formTypeNotifier,
                    ),
                    ValueListenableBuilder(
                      builder: (BuildContext context, value, Widget? child) {
                        return Text.rich(
                          TextSpan(
                            text: value == FormType.signin
                                ? 'Нет аккаунта? '
                                : 'Уже есть аккаунт? ',
                            children: [
                              TextSpan(
                                text: value == FormType.signin
                                    ? 'Регистрация'
                                    : 'Войти',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => _switchType(),
                                style: const TextStyle(
                                  color: secondaryDefault,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                        );
                      },
                      valueListenable: _formTypeNotifier,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthTextField(
                            textFieldType: TextFieldType.email,
                            textFieldController: _emailTextController,
                            validator: FormBuilderValidators.compose(
                              [
                                /// Makes this field required
                                FormBuilderValidators.required(),

                                /// Ensures the value entered is numeric - with custom error message
                                FormBuilderValidators.email(),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          ValueListenableBuilder(
                            valueListenable: _formTypeNotifier,
                            builder: (BuildContext context, FormType value,
                                Widget? child) {
                              return AuthTextField(
                                textFieldType: TextFieldType.password,
                                formType: value,
                                textFieldController: _passwordTextController,
                                validator: FormBuilderValidators.compose([
                                  /// Makes this field required
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(8),
                                ]),
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return PageTransitionSwitcher(
                                duration: const Duration(milliseconds: 500),
                                reverse:
                                    _formTypeNotifier.value != FormType.signin,
                                layoutBuilder: (entries) {
                                  return Stack(
                                    alignment: Alignment.centerLeft,
                                    children: entries,
                                  );
                                },
                                transitionBuilder: (child, primaryAnimation,
                                    secondaryAnimation) {
                                  return SharedAxisTransition(
                                    animation: primaryAnimation,
                                    secondaryAnimation: secondaryAnimation,
                                    transitionType:
                                        SharedAxisTransitionType.horizontal,
                                    child: child,
                                  );
                                },
                                child: value == FormType.signup
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: AuthTextField(
                                          textFieldType:
                                              TextFieldType.repeatPassword,
                                          formType: _formTypeNotifier.value,
                                          validator:
                                              FormBuilderValidators.compose(
                                            [
                                              /// Makes this field required
                                              FormBuilderValidators.required(),

                                              (value) {
                                                if (value !=
                                                    _passwordTextController
                                                        .text) {
                                                  return 'Введенный пароль не совпадает';
                                                }
                                                return null;
                                              }
                                            ],
                                          ),
                                        ),
                                      )
                                    : null,
                              );
                            },
                            valueListenable: _formTypeNotifier,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
