import 'package:animated_checkmark/animated_checkmark.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class ChoicesView extends ConsumerStatefulWidget {
  const ChoicesView({
    super.key,
    required this.provider,
    required this.options,
  });
  final ProviderListenable<List<dynamic>> provider;
  final ProviderListenable<List<String>> options;
  @override
  ConsumerState<ChoicesView> createState() => ChoicesViewState();
}

class ChoicesViewState extends ConsumerState<ChoicesView> {
  late final List<String> options;

  List<String> tags = [];
  @override
  void initState() {
    super.initState();
    options = ref.read(widget.options);
    tags = ref.read(widget.provider).cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return ChipsChoice.multiple(
      direction: Axis.horizontal,
      padding: EdgeInsets.zero,
      choiceCheckmark: false,
      value: tags,
      onChanged: (value) {
        setState(() {
          tags = value;
        });
      },
      // choiceBuilder: (item, i) {
      //   return CustomChip(
      //       label: item.label, selected: item.selected, onSelect: item.select!);
      // },
      choiceItems: C2Choice.listFrom(
        source: options,
        value: (index, item) => item,
        label: (index, item) => item,
      ),
      wrapped: true,

      choiceStyle: C2ChipStyle.outlined(
        borderWidth: 2,
        color: Theme.of(context).colorScheme.onSurface,
        height: 40,
        backgroundOpacity: 1,
        foregroundOpacity: 1,
        foregroundStyle: TextStyle(
          fontSize: 10.sp,
        ),
        checkmarkStyle: CheckmarkStyle.round,
        selectedStyle: C2ChipStyle(
          backgroundAlpha: 0x1A,
          borderColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
