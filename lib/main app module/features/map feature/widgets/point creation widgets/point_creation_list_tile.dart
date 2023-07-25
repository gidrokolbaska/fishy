import 'package:fishy/constants.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class PointCreationListTile extends StatelessWidget {
  const PointCreationListTile({
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
  Widget build(BuildContext context) {
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

                        if (value == null) {
                          return const Icon(Icons.remove);
                        } else {
                          switch (value.runtimeType) {
                            case double:
                              return Text(
                                '${value.toString()} m',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            case String:
                              return Text(value);
                            case DateTime:
                              return Text(
                                MaterialLocalizations.of(context)
                                    .formatShortDate(value),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            case List<String>:
                              if (value.length == 0) {
                                return const Icon(Icons.remove);
                              }

                              return Text(
                                'Выбрано: ${value.length.toString()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            case List<ImageFile>:
                              if (shouldCountExistingFirebaseImages) {
                                return Column(
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
                              return Text(
                                'Выбрано: ${value.length.toString()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            default:
                          }
                        }
                      } else {
                        const Icon(Icons.remove);
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
