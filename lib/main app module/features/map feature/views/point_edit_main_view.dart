import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// import 'package:sheet/route.dart';
// import 'package:sheet/sheet.dart';

const Radius _default_bar_top_radius = Radius.circular(15);

class PointEditMain extends StatefulWidget {
  const PointEditMain({
    Key? key,
    required this.topControl,
    required this.child,
  }) : super(key: key);
  final Widget Function(AnimationController controller) topControl;
  final Widget Function(AnimationController controller) child;

  @override
  State<PointEditMain> createState() => _PointEditMainState();
}

class _PointEditMainState extends State<PointEditMain>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CupertinoScaffold(
        transitionBackgroundColor: Colors.transparent,
        overlayStyle: SystemUiOverlayStyle.light,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //const SizedBox(height: 12),
            SafeArea(
              bottom: false,
              child: widget.topControl(animationController),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              flex: 1,
              child: Material(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: _default_bar_top_radius,
                      topRight: _default_bar_top_radius),
                ),
                clipBehavior: Clip.hardEdge,
                elevation: 2,
                child: widget.child(animationController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
