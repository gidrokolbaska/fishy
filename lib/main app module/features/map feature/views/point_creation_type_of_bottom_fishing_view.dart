import 'package:auto_route/auto_route.dart';

import 'package:fishy/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/point_creation_providers.dart';
import 'choises_view.dart';

class TypeOfBottomBottomSheetPage extends StatelessWidget {
  TypeOfBottomBottomSheetPage({
    Key? key,
    required this.ref,
  }) : super(key: key);
  final GlobalKey<ChoicesViewState> choicesKey = GlobalKey();
  final WidgetRef ref;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              width: 24,
              height: 3,
              decoration: BoxDecoration(
                color: grayscaleLine,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () {
                    context.popRoute();
                  },
                  child: const Text('Отмена'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    ref
                        .read(typeOfBottomSelectedChoicesProvider.notifier)
                        .state = choicesKey.currentState!.tags;

                    context.popRoute();
                  },
                  child: const Text('Готово'),
                )
              ],
            ),
            SafeArea(
              top: false,
              child: ChoicesView(
                key: choicesKey,
                options: typeOfBottomChoicesProvider,
                provider: typeOfBottomSelectedChoicesProvider,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
