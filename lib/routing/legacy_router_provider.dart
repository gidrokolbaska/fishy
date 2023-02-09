// import 'package:fishy/auth%20module/views/auth_screen.dart';
// import 'package:fishy/introduction%20module/views/introduction_screen.dart';

// import 'package:fishy/repositories/local_storage_repo.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../constants.dart';
// import '../main app module/views/fishy_app_stack_screen.dart';
// import '../main app module/views/main_shell_screen.dart';
// import '../providers/auth_provider.dart';
// import '../splash_screen.dart';

// final routerProvider = Provider.autoDispose<GoRouter>(
//   (ref) {
//     final GlobalKey<NavigatorState> _rootNavigatorKey =
//         GlobalKey<NavigatorState>(debugLabel: 'root');
//     final GlobalKey<NavigatorState> _shellNavigatorKey =
//         GlobalKey<NavigatorState>(debugLabel: 'shell');
//     return GoRouter(
//       navigatorKey: _rootNavigatorKey,
//       initialLocation: '/authChecker',
//       routes: [
//         GoRoute(
//           path: '/authChecker',
//           name: 'authChecker',
//           builder: (context, state) => const AuthChecker(),
//         ),
//         GoRoute(
//           path: '/intro',
//           name: 'intro',
//           builder: (context, state) => const FishyIntroductionScreen(),
//         ),
//         GoRoute(
//           path: '/auth',
//           name: 'auth',
//           builder: (context, state) => const AuthScreen(),
//         ),
//         ShellRoute(
//           navigatorKey: _shellNavigatorKey,
//           builder: (context, state, child) {
//             return MainScreen(key: state.pageKey, child: child);
//           },
//           routes: [
//             GoRoute(
//               path: '/fishy',
//               name: 'fishy',
//               builder: (context, state) {
//                 return const FishyApp();
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   },
// );
