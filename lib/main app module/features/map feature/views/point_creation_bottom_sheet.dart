import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';

const Radius _default_bar_top_radius = Radius.circular(15);

class CreatePointBottomSheet extends StatelessWidget {
  const CreatePointBottomSheet(
      {Key? key,
      required this.child,
      this.control,
      this.clipBehavior,
      this.shape,
      this.elevation})
      : super(key: key);
  final Widget child;
  final Widget? control;
  final Clip? clipBehavior;
  final double? elevation;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 12),
              SafeArea(
                bottom: false,
                child: control ??
                    Container(
                      height: 6,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6)),
                    ),
              ),
              const SizedBox(height: 8),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Material(
                  shape: shape ??
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: _default_bar_top_radius,
                            topRight: _default_bar_top_radius),
                      ),
                  clipBehavior: clipBehavior ?? Clip.hardEdge,
                  elevation: elevation ?? 2,
                  child: SizedBox(
                    width: double.infinity,
                    child: MediaQuery.removePadding(
                        context: context, removeTop: true, child: child),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class CreatePointSheetRoute<T> extends SheetRoute<T> {
  CreatePointSheetRoute({
    required WidgetBuilder builder,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color barrierColor = Colors.black87,
    SheetFit fit = SheetFit.expand,
    Curve? animationCurve,
    bool isDismissible = true,
    bool enableDrag = true,
    Widget? topControl,
    Duration? duration,
    RouteSettings? settings,
  }) : super(
          builder: (BuildContext context) {
            return CreatePointBottomSheet(
              control: topControl,
              clipBehavior: clipBehavior,
              shape: shape,
              elevation: elevation,
              child: Builder(builder: builder),
            );
          },
          fit: fit,
          barrierDismissible: isDismissible,
          barrierColor: barrierColor,
          draggable: enableDrag,
          animationCurve: animationCurve,
          duration: duration,
          settings: settings,
        );
}
