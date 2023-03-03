import 'dart:math';

import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/point_creation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

const Size _depthPortraitDialogSize = Size(330.0, 450.0);
const Size _depthLandscapeDialogSize = Size(496.0, 346.0);

class DepthSelectorView extends ConsumerStatefulWidget {
  const DepthSelectorView({
    super.key,
  });

  @override
  ConsumerState<DepthSelectorView> createState() => _DepthSelectorViewState();
}

class _DepthSelectorViewState extends ConsumerState<DepthSelectorView> {
  late WeightSliderController _controller;
  late double? depth;
  @override
  void initState() {
    super.initState();

    depth = ref.read(depthProvider);
    _controller = WeightSliderController(
        initialWeight: depth ?? 0.0, minWeight: 0, interval: 0.1);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Constrain the textScaleFactor to the largest supported value to prevent
    // layout issues.
    final double textScaleFactor =
        min(MediaQuery.of(context).textScaleFactor, 1.3);
    final Size dialogSize = _dialogSize(context) * textScaleFactor;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final Widget actions = Container(
      alignment: AlignmentDirectional.centerEnd,
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: OverflowBar(
        spacing: 8,
        children: <Widget>[
          if (ref.read(depthProvider) != null)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                ref.read(depthProvider.notifier).ref.invalidateSelf();
                Navigator.pop(context);
              },
              child: Text(
                (Theme.of(context).useMaterial3
                    ? localizations.deleteButtonTooltip.toUpperCase()
                    : localizations.deleteButtonTooltip.toUpperCase()),
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              (Theme.of(context).useMaterial3
                  ? localizations.cancelButtonLabel
                  : localizations.cancelButtonLabel.toUpperCase()),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(depthProvider.notifier).state = depth;
              Navigator.pop(context);
            },
            child: Text(
              (Theme.of(context).useMaterial3
                  ? localizations.okButtonLabel
                  : localizations.okButtonLabel.toUpperCase()),
            ),
          ),
          // TextButton(
          //   onPressed: () {},
          //   child: Text((Theme.of(context).useMaterial3
          //       ? localizations.cancelButtonLabel
          //       : localizations.cancelButtonLabel.toUpperCase())),
          // ),
          // TextButton(
          //   onPressed: () {},
          //   child: Text(localizations.okButtonLabel),
          // ),
        ],
      ),
    );
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.hardEdge,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        height: dialogSize.height,
        width: dialogSize.width,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: kToolbarHeight,
              color: primaryColor,
              child: Text(
                'Выберите глубину',
                style: TextStyle(
                  color: grayscaleOffwhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
            Container(
              height: 100.0,
              alignment: Alignment.center,
              child: Text(
                depth == null
                    ? '${_controller.initialWeight.toString()} m'
                    : "${depth!.toStringAsFixed(1)} m",
                style:
                    TextStyle(fontSize: 40.0.sp, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: VerticalWeightSlider(
                controller: _controller,
                maxWeight: 40,
                decoration: PointerDecoration(
                  width: 70.w,
                  height: 3.0,
                  largeColor: const Color(0xFF898989),
                  mediumColor: const Color(0xFFC5C5C5),
                  smallColor: const Color(0xFFF0F0F0),
                  gap: 30.0,
                ),
                onChanged: (double value) {
                  setState(() {
                    depth = value;
                  });
                },
                indicator: Container(
                  height: 5.0,
                  width: 70.w,
                  alignment: Alignment.centerLeft,
                  color: Colors.red[300],
                ),
              ),
            ),
            actions,
          ],
        ),
      ),
    );
  }

  Size _dialogSize(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    switch (orientation) {
      case Orientation.portrait:
        return _depthPortraitDialogSize;
      case Orientation.landscape:
        return _depthLandscapeDialogSize;
    }
  }
}
