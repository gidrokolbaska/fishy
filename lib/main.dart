import 'package:firebase_core/firebase_core.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/repositories/local_storage_repo.dart';
import 'package:fishy/routing/app_router.dart';
import 'package:fishy/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();
  await FlutterMapTileCaching.initialise(
    settings: FMTCSettings(
      defaultTileProviderSettings: FMTCTileProviderSettings(
        behavior: CacheBehavior.cacheFirst,
        cachedValidDuration: const Duration(
          days: 14,
        ),
      ),
    ),
  );
  //create the store for caching tiles
  final store = FMTC.instance('fishyStore');
  await store.manage.createAsync();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(sharedPrefs)],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});
  final _appRouter =
      AppRouter(introductionGuard: IntroductionGuard(), authGuard: AuthGuard());
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: _appRouter.defaultRouteParser(),
          routerDelegate: _appRouter.delegate(),
          supportedLocales: const [
            Locale('ru'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FormBuilderLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
            primaryColor: primaryColor,
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              //onSurface: grayscalePlacehold,
              surfaceTint: Colors.white,
              error: red500,
            ),
            navigationBarTheme: const NavigationBarThemeData(
              indicatorColor: primaryColor,
            ),
            textTheme: TextTheme(
              displayLarge: TextStyle(
                color: blackColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              bodyLarge: TextStyle(
                color: blackColor,
                fontSize: 13.sp,
                letterSpacing: 0.75,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(
                color: grayscaleLabel,
                fontSize: 12.sp,
                letterSpacing: 0.75,
              ),
            ),
            listTileTheme: const ListTileThemeData(
              textColor: grayscaleBody,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: const Color(0xffFCFCFC),
                elevation: 2,
                surfaceTintColor: Colors.white,
                splashFactory: NoSplash.splashFactory,
                textStyle:
                    TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }
}
