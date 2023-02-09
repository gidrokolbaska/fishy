import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fishy/routing/app_router.gr.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appwrite/models.dart' as models;

import '../../providers/user_data_provider.dart';

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
      print(e.toString());
      return null;
    }
  }

  // A function to login the user with email and password
  Future<void> login(String email, String password, BuildContext context,
      WidgetRef ref) async {
    try {
      await account.createEmailSession(email: email, password: password);

      if (context.mounted) {
        context.router.replace(const FishyMainScreenRoute());
      }
    } catch (e) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Error Occured'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        context.router.pop();
                      },
                      child: const Text("Ok"))
                ],
              ));
    }
  }

  ///  A function to signup the user with email and password
  Future<void> signUp(String email, String password, BuildContext context,
      WidgetRef ref) async {
    final _userData = ref.watch(userDataClassProvider);
    try {
      await account
          .create(email: email, password: password, userId: 'unique()')
          .whenComplete(
        () async {
          await account.createEmailSession(email: email, password: password);
          await _userData.addUser();
        },
      );

      if (context.mounted) {
        context.router.replace(const FishyMainScreenRoute());
      }
    } catch (e) {
      log(" Sign Up $e");
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Error Occured'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Ok"))
                ],
              ));
    }
  }

  Future<void> signOut(BuildContext context, WidgetRef ref) async {
    try {
      ///  Delete session is the method to logout the user
      ///  it expects sessionID but by passing 'current' it redirects to
      ///  current loggedIn user in this application
      await account.deleteSession(sessionId: 'current');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text("Logged out Successfully"),
      //   duration: Duration(seconds: 2),
      // ));
      if (context.mounted) {
        context.router.replace(const AuthScreenRoute());
      }
    } catch (e) {
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
              ));
    }
  }
}
