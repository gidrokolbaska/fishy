import 'package:fishy/constants.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';

class PointCreationListTile extends StatelessWidget {
  const PointCreationListTile({
    super.key,
    required this.title,
    this.shouldShowUnderlineBorder = true,
    required this.onTap,
  });
  final String title;
  final bool shouldShowUnderlineBorder;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: grayscaleInput,
            width: 2,
          ),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            FishyIcons.chevronForward,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
