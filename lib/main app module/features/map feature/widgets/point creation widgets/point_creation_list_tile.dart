import 'package:fishy/constants.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';

class PointCreationListTile extends StatelessWidget {
  const PointCreationListTile({
    super.key,
    required this.title,
    this.shouldShowUnderlineBorder = true,
    this.onTap,
    this.subtitle,
    this.showTrailing = true,
  });
  final String title;
  final bool shouldShowUnderlineBorder;
  final VoidCallback? onTap;
  final Widget? subtitle;
  final bool showTrailing;
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
            ? const Icon(
                FishyIcons.chevronForward,
              )
            : null,
        subtitle: subtitle,
        onTap: onTap,
      ),
    );
  }
}
