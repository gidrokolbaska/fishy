import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FishyMapTopButtons extends ConsumerWidget {
  const FishyMapTopButtons({super.key, required this.notifier});

  final ValueListenable notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      builder: (BuildContext context, value, Widget? child) {
        return AnimatedSlide(
          offset: value ? const Offset(0, -1) : Offset.zero,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: child,
        );
      },
      valueListenable: notifier,
      child: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shadowColor: Colors.black,
                  backgroundColor: Theme.of(context).primaryColor,
                  surfaceTintColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 500),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  fixedSize: const Size(56, 56),
                ),
                icon: const Icon(FishyIcons.menuLeft),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              IconButton(
                style: ElevatedButton.styleFrom(
                  animationDuration: const Duration(milliseconds: 500),
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  fixedSize: const Size(56, 56),
                ),
                icon: const Icon(FishyIcons.view),
                onPressed: () {},
              ),
            ],
          ),
        )),
      ),
    );
  }
}
