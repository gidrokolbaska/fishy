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
import 'package:fishy/main%20app%20module/features/map%20feature/views/point_creation_main_view.dart'
    as _i5;
import 'package:fishy/main%20app%20module/views/gallery_screen.dart' as _i8;
import 'package:fishy/main%20app%20module/views/main_wrapper_screen.dart'
    as _i1;
import 'package:fishy/main%20app%20module/views/point_details_screen.dart'
    as _i4;
import 'package:fishy/main%20app%20module/views/points_screen.dart' as _i7;
import 'package:fishy/routing/app_router.dart' as _i11;
import 'package:flutter/material.dart' as _i10;

class AppRouter extends _i9.RootStackRouter {
  AppRouter({
    _i10.GlobalKey<_i10.NavigatorState>? navigatorKey,
    required this.introductionGuard,
    required this.authGuard,
  }) : super(navigatorKey);

  final _i11.IntroductionGuard introductionGuard;

  final _i11.AuthGuard authGuard;

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    FishyMainScreenRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.FishyMainScreen(),
      );
    },
    FishyIntroductionScreenRoute.name: (routeData) {
      final args = routeData.argsAs<FishyIntroductionScreenRouteArgs>(
          orElse: () => const FishyIntroductionScreenRouteArgs());
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.FishyIntroductionScreen(
          key: args.key,
          isComplete: args.isComplete,
        ),
      );
    },
    AuthScreenRoute.name: (routeData) {
      final args = routeData.argsAs<AuthScreenRouteArgs>(
          orElse: () => const AuthScreenRouteArgs());
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i3.AuthScreen(
          key: args.key,
          onLoginResult: args.onLoginResult,
        ),
        maintainState: false,
      );
    },
    PointDetailsScreenRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.PointDetailsScreen(),
      );
    },
    PointCreationMainRoute.name: (routeData) {
      final args = routeData.argsAs<PointCreationMainRouteArgs>();
      return _i9.CustomPage<dynamic>(
        routeData: routeData,
        child: _i5.PointCreationMain(
          key: args.key,
          topControl: args.topControl,
          child: args.child,
        ),
        customRouteBuilder: _i11.modalsPageRoute,
        opaque: true,
        barrierDismissible: false,
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
          redirectTo: '/main',
          fullMatch: true,
        ),
        _i9.RouteConfig(
          FishyMainScreenRoute.name,
          path: '/main',
          guards: [
            introductionGuard,
            authGuard,
          ],
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
          FishyIntroductionScreenRoute.name,
          path: '/intro',
        ),
        _i9.RouteConfig(
          AuthScreenRoute.name,
          path: '/auth',
        ),
        _i9.RouteConfig(
          PointDetailsScreenRoute.name,
          path: '/pointDetails',
        ),
        _i9.RouteConfig(
          PointCreationMainRoute.name,
          path: '/point-creation-main',
        ),
      ];
}

/// generated route for
/// [_i1.FishyMainScreen]
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
/// [_i2.FishyIntroductionScreen]
class FishyIntroductionScreenRoute
    extends _i9.PageRouteInfo<FishyIntroductionScreenRouteArgs> {
  FishyIntroductionScreenRoute({
    _i10.Key? key,
    void Function(bool)? isComplete,
  }) : super(
          FishyIntroductionScreenRoute.name,
          path: '/intro',
          args: FishyIntroductionScreenRouteArgs(
            key: key,
            isComplete: isComplete,
          ),
        );

  static const String name = 'FishyIntroductionScreenRoute';
}

class FishyIntroductionScreenRouteArgs {
  const FishyIntroductionScreenRouteArgs({
    this.key,
    this.isComplete,
  });

  final _i10.Key? key;

  final void Function(bool)? isComplete;

  @override
  String toString() {
    return 'FishyIntroductionScreenRouteArgs{key: $key, isComplete: $isComplete}';
  }
}

/// generated route for
/// [_i3.AuthScreen]
class AuthScreenRoute extends _i9.PageRouteInfo<AuthScreenRouteArgs> {
  AuthScreenRoute({
    _i10.Key? key,
    void Function(bool)? onLoginResult,
  }) : super(
          AuthScreenRoute.name,
          path: '/auth',
          args: AuthScreenRouteArgs(
            key: key,
            onLoginResult: onLoginResult,
          ),
        );

  static const String name = 'AuthScreenRoute';
}

class AuthScreenRouteArgs {
  const AuthScreenRouteArgs({
    this.key,
    this.onLoginResult,
  });

  final _i10.Key? key;

  final void Function(bool)? onLoginResult;

  @override
  String toString() {
    return 'AuthScreenRouteArgs{key: $key, onLoginResult: $onLoginResult}';
  }
}

/// generated route for
/// [_i4.PointDetailsScreen]
class PointDetailsScreenRoute extends _i9.PageRouteInfo<void> {
  const PointDetailsScreenRoute()
      : super(
          PointDetailsScreenRoute.name,
          path: '/pointDetails',
        );

  static const String name = 'PointDetailsScreenRoute';
}

/// generated route for
/// [_i5.PointCreationMain]
class PointCreationMainRoute
    extends _i9.PageRouteInfo<PointCreationMainRouteArgs> {
  PointCreationMainRoute({
    _i10.Key? key,
    required _i10.Widget Function(_i10.AnimationController) topControl,
    required _i10.Widget Function(_i10.AnimationController) child,
  }) : super(
          PointCreationMainRoute.name,
          path: '/point-creation-main',
          args: PointCreationMainRouteArgs(
            key: key,
            topControl: topControl,
            child: child,
          ),
        );

  static const String name = 'PointCreationMainRoute';
}

class PointCreationMainRouteArgs {
  const PointCreationMainRouteArgs({
    this.key,
    required this.topControl,
    required this.child,
  });

  final _i10.Key? key;

  final _i10.Widget Function(_i10.AnimationController) topControl;

  final _i10.Widget Function(_i10.AnimationController) child;

  @override
  String toString() {
    return 'PointCreationMainRouteArgs{key: $key, topControl: $topControl, child: $child}';
  }
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
