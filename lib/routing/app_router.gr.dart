// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:fishy/auth%20module/views/auth_screen.dart' as _i3;
import 'package:fishy/introduction%20module/views/introduction_screen.dart'
    as _i2;
import 'package:fishy/main%20app%20module/features/map%20feature/views/map_screen.dart'
    as _i6;
import 'package:fishy/main%20app%20module/views/gallery_screen.dart' as _i8;
import 'package:fishy/main%20app%20module/views/main_wrapper_screen.dart'
    as _i4;
import 'package:fishy/main%20app%20module/views/point_details_screen.dart'
    as _i5;
import 'package:fishy/main%20app%20module/views/points_screen.dart' as _i7;
import 'package:fishy/splash_screen.dart' as _i1;
import 'package:flutter/material.dart' as _i10;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    AuthCheckerRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.AuthChecker(),
      );
    },
    FishyIntroductionScreenRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.FishyIntroductionScreen(),
      );
    },
    AuthScreenRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.AuthScreen(),
      );
    },
    FishyMainScreenRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.FishyMainScreen(),
      );
    },
    PointDetailsScreenRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.PointDetailsScreen(),
      );
    },
    FishyMapScreenRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.FishyMapScreen(),
      );
    },
    FishyPointsScreenRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.FishyPointsScreen(),
      );
    },
    FishyGalleryScreenRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.FishyGalleryScreen(),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/splash',
          fullMatch: true,
        ),
        _i9.RouteConfig(
          AuthCheckerRoute.name,
          path: '/splash',
        ),
        _i9.RouteConfig(
          FishyIntroductionScreenRoute.name,
          path: '/intro',
        ),
        _i9.RouteConfig(
          AuthScreenRoute.name,
          path: '/auth',
        ),
        _i9.RouteConfig(
          FishyMainScreenRoute.name,
          path: '/main',
          children: [
            _i9.RouteConfig(
              FishyMapScreenRoute.name,
              path: '',
              parent: FishyMainScreenRoute.name,
            ),
            _i9.RouteConfig(
              FishyPointsScreenRoute.name,
              path: '',
              parent: FishyMainScreenRoute.name,
            ),
            _i9.RouteConfig(
              FishyGalleryScreenRoute.name,
              path: '',
              parent: FishyMainScreenRoute.name,
            ),
          ],
        ),
        _i9.RouteConfig(
          PointDetailsScreenRoute.name,
          path: '/pointDetails',
        ),
      ];
}

/// generated route for
/// [_i1.AuthChecker]
class AuthCheckerRoute extends _i9.PageRouteInfo<void> {
  const AuthCheckerRoute()
      : super(
          AuthCheckerRoute.name,
          path: '/splash',
        );

  static const String name = 'AuthCheckerRoute';
}

/// generated route for
/// [_i2.FishyIntroductionScreen]
class FishyIntroductionScreenRoute extends _i9.PageRouteInfo<void> {
  const FishyIntroductionScreenRoute()
      : super(
          FishyIntroductionScreenRoute.name,
          path: '/intro',
        );

  static const String name = 'FishyIntroductionScreenRoute';
}

/// generated route for
/// [_i3.AuthScreen]
class AuthScreenRoute extends _i9.PageRouteInfo<void> {
  const AuthScreenRoute()
      : super(
          AuthScreenRoute.name,
          path: '/auth',
        );

  static const String name = 'AuthScreenRoute';
}

/// generated route for
/// [_i4.FishyMainScreen]
class FishyMainScreenRoute extends _i9.PageRouteInfo<void> {
  const FishyMainScreenRoute({List<_i9.PageRouteInfo>? children})
      : super(
          FishyMainScreenRoute.name,
          path: '/main',
          initialChildren: children,
        );

  static const String name = 'FishyMainScreenRoute';
}

/// generated route for
/// [_i5.PointDetailsScreen]
class PointDetailsScreenRoute extends _i9.PageRouteInfo<void> {
  const PointDetailsScreenRoute()
      : super(
          PointDetailsScreenRoute.name,
          path: '/pointDetails',
        );

  static const String name = 'PointDetailsScreenRoute';
}

/// generated route for
/// [_i6.FishyMapScreen]
class FishyMapScreenRoute extends _i9.PageRouteInfo<void> {
  const FishyMapScreenRoute()
      : super(
          FishyMapScreenRoute.name,
          path: '',
        );

  static const String name = 'FishyMapScreenRoute';
}

/// generated route for
/// [_i7.FishyPointsScreen]
class FishyPointsScreenRoute extends _i9.PageRouteInfo<void> {
  const FishyPointsScreenRoute()
      : super(
          FishyPointsScreenRoute.name,
          path: '',
        );

  static const String name = 'FishyPointsScreenRoute';
}

/// generated route for
/// [_i8.FishyGalleryScreen]
class FishyGalleryScreenRoute extends _i9.PageRouteInfo<void> {
  const FishyGalleryScreenRoute()
      : super(
          FishyGalleryScreenRoute.name,
          path: '',
        );

  static const String name = 'FishyGalleryScreenRoute';
}
