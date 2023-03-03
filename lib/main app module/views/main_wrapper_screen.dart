import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fishy/auth%20module/repositories/authentication_repository.dart';

import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:fishy/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../auth module/providers/auth_provider.dart';
import '../../constants.dart';

class FishyMainScreen extends ConsumerStatefulWidget {
  const FishyMainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestMainScreenState();
}

class _TestMainScreenState extends ConsumerState<FishyMainScreen> {
  late final AuthenticationRepository auth;
  @override
  void initState() {
    super.initState();
    auth = ref.read(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    // final position = ref.watch(fishyAppNavigationProvider);
    // final appBarTitle = ref.watch(appBarTitleProvider);
    return AutoTabsRouter(
      lazyLoad: true,
      homeIndex: -1,
      routes: const [
        FishyMapScreenRoute(),
        FishyPointsScreenRoute(),
        FishyGalleryScreenRoute(),
      ],
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: grayscaleBG,
          appBar: tabsRouter.activeIndex != 0
              ? AppBar(
                  automaticallyImplyLeading: false,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  leadingWidth: 56 + 18,
                  leading: AutoLeadingButton(
                    builder: (context, leadingType, action) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: IconButton(
                          style: tabsRouter.activeIndex != 0
                              ? ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: const CircleBorder())
                              : ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  fixedSize: const Size(48, 48),
                                ),
                          icon: const Icon(FishyIcons.menuLeft),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      );
                    },
                  ),
                  backgroundColor: tabsRouter.activeIndex != 0
                      ? primaryColor
                      : Colors.transparent,
                  centerTitle: true,
                  title: Text(
                    tabsRouter.activeIndex == 1
                        ? 'Места улова'
                        : 'Галерея улова',
                    style: TextStyle(
                      color: grayscaleOffwhite,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
              : null,
          drawer: Drawer(
            child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    auth.signOut(context, ref);
                  },
                  child: const Text('logout')),
            ),
          ),
          body: FadeThroughTransition(
            fillColor: Colors.transparent,
            animation: animation,
            secondaryAnimation: ReverseAnimation(animation),
            child: child,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: (value) {
              tabsRouter.setActiveIndex(value);
            },
            destinations: const [
              NavigationDestination(
                  icon: Icon(
                    FishyIcons.map,
                  ),
                  label: 'Карта'),
              NavigationDestination(
                  icon: Icon(
                    FishyIcons.location,
                  ),
                  label: 'Мои места'),
              NavigationDestination(
                  icon: Icon(
                    FishyIcons.gallery,
                  ),
                  label: 'Галерея')
            ],
          ),
        );
      },
    );
  }
}
