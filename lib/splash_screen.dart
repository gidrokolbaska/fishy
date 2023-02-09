//TODO: implement proper splash screen

import 'package:auto_route/auto_route.dart';
import 'package:fishy/providers/auth_provider.dart';
import 'package:fishy/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'repositories/local_storage_repo.dart';

class AuthChecker extends ConsumerStatefulWidget {
  const AuthChecker({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends ConsumerState<AuthChecker> {
  late final SharedPreferences introState;
  bool? isIntroCompleted;
  @override
  void initState() {
    super.initState();
    introState = ref.read(sharedPrefsProvider);
    isIntroCompleted = introState.getBool(introCompletedKey);
  }

  void navigate(BuildContext context, PageRouteInfo pathName) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.router.replace(pathName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
        body: user.when(
      data: (data) {
        if (isIntroCompleted == null) {
          navigate(context, const FishyIntroductionScreenRoute());
          return null;
        } else {
          if (data != null) {
            navigate(context, const FishyMainScreenRoute());
            return null;
          } else {
            navigate(
              context,
              const AuthScreenRoute(),
            );
            return null;
          }
        }
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    ));
  }
}
