import 'package:fishy/constants.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FishyMapTopButtons extends StatelessWidget {
  const FishyMapTopButtons({super.key, required this.notifier});

  final ValueListenable notifier;

  @override
  Widget build(BuildContext context) {
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
              FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 5,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  //shadowColor: Colors.black,
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: grayscaleOffBlack,
                  surfaceTintColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fixedSize: const Size(56, 56),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                onLongPress: () {},
                child: const Icon(FishyIcons.menuLeft),
              ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     elevation: 5,
              //     padding: EdgeInsets.zero,
              //     //shadowColor: Colors.black,
              //     backgroundColor: Theme.of(context).primaryColor,
              //     foregroundColor: grayscaleOffBlack,
              //     surfaceTintColor: Colors.white,
              //     animationDuration: const Duration(milliseconds: 500),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     fixedSize: const Size(56, 56),
              //   ),
              //   onPressed: () {
              //     Scaffold.of(context).openDrawer();
              //   },
              //   onLongPress: () {},
              //   child: const Icon(FishyIcons.menuLeft),
              // ),
              FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 0,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  //shadowColor: Colors.black,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.6),
                  foregroundColor: grayscaleOffBlack,
                  surfaceTintColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fixedSize: const Size(56, 56),
                ),
                onPressed: () {},
                onLongPress: () {},
                child: const Icon(FishyIcons.view),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
