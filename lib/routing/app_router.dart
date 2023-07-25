import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishy/auth%20module/views/auth_screen.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/introduction%20module/views/introduction_screen.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/views/map_screen.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/views/point_creation_main_view.dart';
import 'package:fishy/main%20app%20module/views/points_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main app module/views/gallery_screen.dart';
import '../main app module/views/main_wrapper_screen.dart';
import '../main app module/views/point_details_screen.dart';
import 'app_router.gr.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(
      page: FishyMainScreen,
      path: '/main',
      initial: true,
      guards: [IntroductionGuard, AuthGuard],
      children: [
        AutoRoute(
          path: '',
          page: FishyMapScreen,
        ),
        AutoRoute(
          path: '',
          page: FishyPointsScreen,
        ),
        AutoRoute(
          path: '',
          page: FishyGalleryScreen,
        ),
      ],
    ),
    AutoRoute(page: FishyIntroductionScreen, path: '/intro'),
    AutoRoute(
      page: AuthScreen,
      path: '/auth',
      maintainState: false,
    ),
    AutoRoute(page: PointDetailsScreen, path: '/pointDetails'),
    CustomRoute(page: PointCreationMain, customRouteBuilder: modalsPageRoute),
  ],
)
class $AppRouter {}

class AuthGuard extends AutoRedirectGuard {
  User? authUser;
  bool isVerified = false;
  AuthGuard() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && user.emailVerified) {
        authUser = user;
        isVerified = user.emailVerified;
        reevaluate();
      } else {
        authUser = user;
        isVerified = user?.emailVerified ?? false;
        reevaluate();
      }
    });
  }
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (await canNavigate(resolver.route)) {
      resolver.next();
    } else {
      redirect(AuthScreenRoute(
        onLoginResult: (p0) {
          isVerified = p0;
          resolver.next(isVerified);
        },
      ), resolver: resolver);
    }
  }

  @override
  Future<bool> canNavigate(RouteMatch route) async {
    return authUser != null && isVerified;
  }
}

class IntroductionGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    bool? isIntroCompleted = sharedPrefs.getBool(introCompletedKey);
    if (isIntroCompleted != null) {
      resolver.next(true);
    } else {
      router.push(FishyIntroductionScreenRoute(isComplete: (isComplete) {
        resolver.next(isComplete);
        router.removeLast();
      }));
    }
  }
}

Route<T> modalsPageRoute<T>(
  BuildContext context,
  Widget child,
  CustomPage<T> page,
) {
  return ModalSheetRoute(
    settings: page,
    enableDrag: true,
    modalBarrierColor:
        page.barrierColor == null ? null : Color(page.barrierColor!),
    isDismissible: page.barrierDismissible,
    closeProgressThreshold: 0.6,
    animationCurve: Curves.fastOutSlowIn,
    builder: (_) => child,
    expanded: true,
  );
}
