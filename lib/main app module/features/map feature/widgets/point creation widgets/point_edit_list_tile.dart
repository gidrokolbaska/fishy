import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/point_creation_providers.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PointEditListTile extends ConsumerWidget {
  const PointEditListTile({
    super.key,
    required this.title,
    this.shouldShowUnderlineBorder = true,
    this.onTap,
    this.subtitle,
    this.showTrailing = true,
    this.provider,
    this.enabled = true,
    this.shouldCountExistingFirebaseImages = false,
    this.amountOfExistingFirebaseImages = 0,
  });
  final String title;
  final bool shouldShowUnderlineBorder;
  final VoidCallback? onTap;
  final Widget? subtitle;
  final bool showTrailing;
  final bool enabled;

  final ProviderListenable? provider;
  final bool shouldCountExistingFirebaseImages;
  final int amountOfExistingFirebaseImages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String>? onlineImagesFromProvider =
        ref.watch(selectedOnlinePhotosListProvider);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: shouldShowUnderlineBorder
            ? const Border(
                bottom: BorderSide(
                  color: grayscaleInput,
                  width: 2,
                ),
              )
            : const Border(
                bottom: BorderSide.none,
              ),
      ),
      child: ListTile(
        dense: true,
        enabled: enabled,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: showTrailing
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      if (provider != null) {
                        final value = ref.watch(provider!);

                        if (value == null &&
                            !shouldCountExistingFirebaseImages) {
                          return const Icon(Icons.remove);
                        } else {
                          if (onlineImagesFromProvider != null &&
                              value == null) {
                            return Text(
                              'Текущие: ${onlineImagesFromProvider.length}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (amountOfExistingFirebaseImages > 0 &&
                              value == null) {
                            return Text(
                              'Текущие: $amountOfExistingFirebaseImages',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else if (amountOfExistingFirebaseImages == 0 &&
                              value != null) {
                            return Text(
                              'Выбрано: ${value.length}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else if (onlineImagesFromProvider != null &&
                              value != null) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Текущие: ${onlineImagesFromProvider.length}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Выбрано: ${value.length}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Текущие: $amountOfExistingFirebaseImages',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Выбрано: ${value.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        }
                      }

                      return const Icon(Icons.remove);
                    },
                  ),
                  const Icon(
                    FishyIcons.chevron_forward,
                  )
                ],
              )
            : null,
        subtitle: subtitle,
        onTap: onTap,
      ),
    );
  }
}
