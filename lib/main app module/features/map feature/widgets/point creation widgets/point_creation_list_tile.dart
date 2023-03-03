import 'package:fishy/constants.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PointCreationListTile extends StatelessWidget {
  const PointCreationListTile({
    super.key,
    required this.title,
    this.shouldShowUnderlineBorder = true,
    this.onTap,
    this.subtitle,
    this.showTrailing = true,
    this.provider,
  });
  final String title;
  final bool shouldShowUnderlineBorder;
  final VoidCallback? onTap;
  final Widget? subtitle;
  final bool showTrailing;

  final ProviderListenable? provider;

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
                                style: TextStyle(
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
                    FishyIcons.chevronForward,
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
