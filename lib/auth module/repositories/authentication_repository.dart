import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // A function to login the user with email and password
  Future<void> login(
    String email,
    String password,
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // onLoginResult!(true);
    } on FirebaseAuthException catch (e) {
      late String errorMessage;
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage = 'Отсутствует подключение к интернету';
      }
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Пользователя с таким email не существует';
          break;
        case 'wrong-password':
          errorMessage = 'Введён неверный пароль';
          break;
        default:
          errorMessage = e.toString();
      }

      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Внимание'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  context.router.pop();
                },
                child: const Text("ОК"),
              )
            ],
          ),
        );
      }
    }
  }

  Future<void> addUserDefaults() async {
    var snapshot = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      return;
    } else {
      firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'email': FirebaseAuth.instance.currentUser!.email,
      });
    }
  }

  ///  A function to signup the user with email and password
  Future<void> signUp(String email, String password, BuildContext context,
      WidgetRef ref, void Function(bool)? onLoginCallback) async {
    try {
      //create account
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (!credential.user!.emailVerified) {
        await credential.user?.sendEmailVerification();

        await addUserDefaults();
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (BuildContext context) => VerificationDialogWidget(
              onLoginCallback: onLoginCallback,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.toString();
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage = 'Отсутствует подключение к интернету';
      }
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              'Пользователь с такими данными уже существует. Перейдите на экран авторизации';
          break;
      }
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Внимание'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("ОК"),
              )
            ],
          ),
        );
      }
    }
  }

  Future<void> signOut(BuildContext context, WidgetRef ref) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {}
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    OAuthCredential? credential;

    // Create a new credential
    try {
      credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
    } catch (e) {
      return;
    }

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    await addUserDefaults();
  }
}

class VerificationDialogWidget extends StatefulWidget {
  const VerificationDialogWidget({
    super.key,
    required this.onLoginCallback,
  });
  final void Function(bool)? onLoginCallback;

  @override
  State<VerificationDialogWidget> createState() =>
      _VerificationDialogWidgetState();
}

class _VerificationDialogWidgetState extends State<VerificationDialogWidget> {
  late Timer _timer;
  bool isVerified = false;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        setState(() {
          isVerified = true;
        });
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Верификация'),
      content: const Text(
          'На указанную почту было отправлено письмо с ссылкой для верификации аккаунта. Перейдите в своё приложение для почты и перейдите по предоставленной ссылке. После чего нажмите на кнопку "Подтвердить" внизу этого окна'),
      actions: [
        TextButton(
          onPressed: !isVerified
              ? null
              : () async {
                  widget.onLoginCallback!(true);
                  if (!mounted) return;
                  context.router.pop();
                },
          child: const Text("ПОДТВЕРДИТЬ"),
        )
      ],
    );
  }
}
