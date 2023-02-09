import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fishy/auth%20module/views/auth_screen.dart';
import 'package:fishy/introduction%20module/views/introduction_screen.dart';

import 'package:fishy/main%20app%20module/features/map%20feature/views/map_screen.dart';
import 'package:fishy/main%20app%20module/views/points_screen.dart';
import 'package:fishy/splash_screen.dart';
import 'package:flutter/material.dart';

import '../main app module/views/gallery_screen.dart';
import '../main app module/views/main_wrapper_screen.dart';
import '../main app module/views/point_details_screen.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: AuthChecker, path: '/splash', initial: true),
    AutoRoute(page: FishyIntroductionScreen, path: '/intro'),
    AutoRoute(page: AuthScreen, path: '/auth'),
    AutoRoute(
      page: FishyMainScreen,
      path: '/main',
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
    AutoRoute(page: PointDetailsScreen, path: '/pointDetails')
  ],
)
class $AppRouter {}

Widget fadeThroughTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  // you get an animation object and a widget
  // make your own transition
  return FadeThroughTransition(
    animation: animation,
    secondaryAnimation: secondaryAnimation,
    child: child,
  );
}
