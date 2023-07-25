import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishy/auth%20module/repositories/authentication_repository.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:fishy/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
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
                          icon: const Icon(FishyIcons.menu_left),
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
                  ),
                )
              : null,
          drawer: FishyDrawer(auth: auth, ref: ref),
          body: FadeThroughTransition(
            fillColor: Colors.transparent,
            animation: animation,
            secondaryAnimation: ReverseAnimation(animation),
            child: child,
          ),
          bottomNavigationBar: StylishBottomBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (value) {
              tabsRouter.setActiveIndex(value);
              if (value != 0) {
                BotToast.cleanAll();
              }
            },
            items: [
              BottomBarItem(
                icon: const Icon(FishyIcons.map),
                title: const Text('Карта'),
                selectedColor: Theme.of(context).colorScheme.primary,
              ),
              BottomBarItem(
                icon: const Icon(FishyIcons.location),
                title: const Text('Мои места'),
                selectedColor: Theme.of(context).colorScheme.primary,
              ),
              BottomBarItem(
                icon: const Icon(FishyIcons.gallery),
                title: const Text('Галерея'),
                selectedColor: Theme.of(context).colorScheme.primary,
              ),
            ],
            option: AnimatedBarOptions(
              iconStyle: IconStyle.Default,
              barAnimation: BarAnimation.fade,
              inkEffect: false,
            ),
          ),
          //  NavigationBar(
          //   selectedIndex: tabsRouter.activeIndex,
          //   onDestinationSelected: (value) {
          //     tabsRouter.setActiveIndex(value);
          //   },
          //   destinations: const [
          //     NavigationDestination(
          //         icon: Icon(
          //           FishyIcons.map,
          //         ),
          //         label: 'Карта'),
          //     NavigationDestination(
          //         icon: Icon(
          //           FishyIcons.location,
          //         ),
          //         label: 'Мои места'),
          //     NavigationDestination(
          //         icon: Icon(
          //           FishyIcons.gallery,
          //         ),
          //         label: 'Галерея')
          //   ],
          // ),
        );
      },
    );
  }
}

const double _kDrawerHeaderHeight = 160.0 + 1.0;

class FishyDrawer extends StatelessWidget {
  const FishyDrawer({
    super.key,
    required this.auth,
    required this.ref,
  });

  final AuthenticationRepository auth;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.paddingOf(context).top;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: statusBarHeight),
        children: [
          ExpansionTile(
            childrenPadding: const EdgeInsets.all(10.0),
            title: Text(
              FirebaseAuth.instance.currentUser!.email!,
              style: TextStyle(
                fontSize: 13.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(260, 40),
                ),
                onPressed: () {
                  auth.signOut(context, ref);
                },
                child: const Text('Выйти из аккаунта'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: red500,
                  fixedSize: const Size(260, 40),
                ),
                onPressed: () {},
                child: const Text('Удалить аккаунт'),
              ),
            ],
          ),
          ListTile(
            titleTextStyle: TextStyle(
              color: grayscaleLabel,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
            title: const Text(
              'Сообщить об ошибке',
            ),
            leading: const Icon(
              FishyIcons.bug,
            ),
            onTap: () {},
          ),
          ListTile(
            titleTextStyle: TextStyle(
              color: grayscaleLabel,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
            title: const Text(
              'Политика конфиденциальности',
            ),
            leading: const Icon(
              Icons.lock_outline_rounded,
            ),
            onTap: () {},
          ),
          ListTile(
            titleTextStyle: TextStyle(
              color: grayscaleLabel,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
            title: const Text(
              'Условия использования',
            ),
            leading: const Icon(
              FishyIcons.question,
            ),
            onTap: () {},
          )
        ],
      ),
      // Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       auth.signOut(context, ref);
      //     },
      //     child: const Text('logout'),
      //   ),
      // ),
    );
  }
}
