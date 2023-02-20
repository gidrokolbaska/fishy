import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fishy/api/providers/user_repository_provider.dart';

import 'package:fishy/routing/app_router.gr.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appwrite/models.dart' as models;
import 'package:uni_links/uni_links.dart';

class DeeplinkNotifier extends StateNotifier<Uri?> {
  DeeplinkNotifier() : super(null) {
    initDeeplinksForAccountVerification();
  }
  StreamSubscription<Uri?>? sub;

  void initDeeplinksForAccountVerification() async {
    sub = uriLinkStream.listen((Uri? uri) {
      state = uri;
    }, onError: (Object error) {
      debugPrint('$error');
    });
  }

  @override
  void dispose() {
    super.dispose();
    sub?.cancel();
    sub = null;
  }
}

final deeplinkNotifierProvider =
    StateNotifierProvider.autoDispose<DeeplinkNotifier, Uri?>(
        (ref) => DeeplinkNotifier());

class Authentication {
  Authentication(this.client) {
    account = Account(client);
  }

  final Client client;
  late Account account;

  ///  This is a function [getAccount] which will return a [Account] object containing the data
  ///  of the user if the user is authenticated. Otherwise it will throw an exception
  ///  SO we don't want the program to stop in between so we are returning NULL if
  ///  it throws exception
  Future<models.Account?> getAccount() async {
    try {
      return await account.get();
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // A function to login the user with email and password
  Future<void> login(String email, String password, BuildContext context,
      WidgetRef ref) async {
    //TODO: implement account verification here as well
    try {
      await account.createEmailSession(email: email, password: password);

      if (context.mounted) {
        context.router.replace(const FishyMainScreenRoute());
      }
    } on AppwriteException catch (e) {
      late String errorMessage;
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage = 'Отсутствует подключение к интернету';
      }
      switch (e.type) {
        case 'user_invalid_credentials':
          errorMessage =
              'Введены неверная почта или пароль. Либо такого аккаунта не существует';
          break;
        case 'user_already_exists':
          errorMessage =
              'Пользователь с такими данными уже существует. Перейдите на экран авторизации';
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

  ///  A function to signup the user with email and password
  Future<void> signUp(String email, String password, BuildContext context,
      WidgetRef ref) async {
    final userData = ref.read(userRepositoryProvider);
    final kEmail = email;
    final kPassword = password;
    try {
      //create account
      models.Account createdAccount = await account.create(
          email: kEmail, password: kPassword, userId: ID.unique());

      //show the dialog in order to ask the user to verify the account if it is not verified
      if (createdAccount.emailVerification == false) {
        //create the session (login) in order to be able to send the verification email
        await account.createEmailSession(email: kEmail, password: kPassword);

        //send the account verification email
        await account.createVerification(
          url: 'http://192.168.0.101:5500',
        );

        if (context.mounted) {
          // account.updateVerification(
          //     userId: , secret: );
          await showDialog(
            context: context,
            builder: (BuildContext context) => const VerificationDialogWidget(),
          );
          await userData.addUser();
          if (context.mounted) {
            context.router.replace(const FishyMainScreenRoute());
          }
        }
      }
    } on AppwriteException catch (e) {
      String errorMessage = e.toString();
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage = 'Отсутствует подключение к интернету';
      }
      switch (e.type) {
        case 'user_already_exists':
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
      ///  Delete session is the method to logout the user
      ///  it expects sessionID but by passing 'current' it redirects to
      ///  current loggedIn user in this application
      await account.deleteSession(sessionId: 'current');

      if (context.mounted) {
        context.router.replace(const AuthScreenRoute());
      }
    } on AppwriteException catch (e) {
      // print(e);
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Something went wrong'),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"))
          ],
        ),
      );
    }
  }
}

class VerificationDialogWidget extends ConsumerWidget {
  const VerificationDialogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deeplinkUri = ref.watch(deeplinkNotifierProvider);
    return AlertDialog(
      title: const Text('Верификация'),
      content: const Text(
          'На указанную почту было отправлено письмо с ссылкой для верификации аккаунта. Перейдите в своё приложение для почты и перейдите по предоставленной ссылке. После чего нажмите на кнопку "Подтвердить" внизу этого окна'),
      actions: [
        TextButton(
          onPressed: deeplinkUri == null
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: const Text("ПОДТВЕРДИТЬ"),
        )
      ],
    );
  }
}
