import 'package:auto_route/auto_route.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import 'package:sizer/sizer.dart';

class FishyMapTopButtons extends StatelessWidget {
  const FishyMapTopButtons({
    super.key,
    required this.notifier,
    required this.mapController,
  });

  final ValueListenable notifier;
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (BuildContext context, value, Widget? child) {
        return AnimatedSlide(
          offset: value ? const Offset(0, -1) : Offset.zero,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: child,
        );
      },
      valueListenable: notifier,
      child: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 5,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  //shadowColor: Colors.black,
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: grayscaleOffBlack,
                  surfaceTintColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fixedSize: const Size(56, 56),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                onLongPress: () {},
                child: const Icon(FishyIcons.menu_left),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 0,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  //shadowColor: Colors.black,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.6),
                  foregroundColor: grayscaleOffBlack,
                  surfaceTintColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fixedSize: const Size(56, 56),
                ),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: 'coordinates',
                    transitionBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween(
                          begin: const Offset(0.0, 1.0),
                          end: const Offset(0.0, 0.19),
                        ).animate(animation),
                        child: child,
                      );
                    },
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return CoordinatesSelector(
                        mapController: mapController,
                      );
                    },
                  );
                },
                onLongPress: () {},
                child: const Icon(Icons.search_rounded),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class CoordinatesSelector extends StatefulWidget {
  const CoordinatesSelector({
    super.key,
    required this.mapController,
  });
  final MapController mapController;
  @override
  State<CoordinatesSelector> createState() => _CoordinatesSelectorState();
}

class _CoordinatesSelectorState extends State<CoordinatesSelector> {
  final formKey = GlobalKey<FormState>();
  final formatter = FilteringTextInputFormatter.allow(
    RegExp(
      r'^[0-9-.]+',
      caseSensitive: false,
    ),
  );
  final latitudeTextEditingController = TextEditingController();
  final longituteTextEditingController = TextEditingController();

  @override
  void dispose() {
    latitudeTextEditingController.dispose();
    longituteTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      contentPadding: const EdgeInsets.all(14.0),
      content: SizedBox(
        width: 100.w,
        height: 180,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Широта',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: latitudeTextEditingController,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          inputFormatters: [
                            formatter,
                            LengthLimitingTextInputFormatter(
                              13,
                            )
                          ],
                          contextMenuBuilder: (context, editableTextState) {
                            return AdaptiveTextSelectionToolbar.editable(
                              anchors: editableTextState.contextMenuAnchors,
                              clipboardStatus:
                                  editableTextState.clipboardStatus.value,
                              onCopy: editableTextState
                                      .textEditingValue.text.isNotEmpty
                                  ? () {
                                      editableTextState.copySelection(
                                          SelectionChangedCause.toolbar);
                                    }
                                  : null,
                              // to apply the normal behavior when click on cut
                              onCut: editableTextState
                                      .textEditingValue.text.isNotEmpty
                                  ? () => editableTextState.cutSelection(
                                      SelectionChangedCause.toolbar)
                                  : null,
                              onPaste: () async {
                                // HERE will be called when the paste button is clicked in the toolbar
                                // apply your own logic here
                                if (editableTextState.widget.readOnly) {
                                  return;
                                }
                                final TextSelection selection =
                                    editableTextState
                                        .textEditingValue.selection;
                                if (!selection.isValid) {
                                  return;
                                }
                                // Snapshot the input before using `await`.
                                // See https://github.com/flutter/flutter/issues/11427
                                final ClipboardData? data =
                                    await Clipboard.getData(
                                        Clipboard.kTextPlain);
                                if (data == null) {
                                  return;
                                }

                                // After the paste, the cursor should be collapsed and located after the
                                // pasted content.
                                final int lastSelectionIndex = math.max(
                                    selection.baseOffset,
                                    selection.extentOffset);
                                final TextEditingValue
                                    collapsedTextEditingValue =
                                    editableTextState.textEditingValue.copyWith(
                                  selection: TextSelection.collapsed(
                                      offset: lastSelectionIndex),
                                );
                                //lastSelectionIndex,lastSelectionIndex2
                                //59.930484606271804,30.360877635084904
                                final coordinatesList = data.text!.split(',');
                                editableTextState.userUpdateTextEditingValue(
                                  collapsedTextEditingValue.replaced(
                                    selection,
                                    coordinatesList.first,
                                  ),
                                  SelectionChangedCause.toolbar,
                                );
                                //Обовляем второе поле с долготой, если список состоит из двух значений
                                if (coordinatesList.length > 1 &&
                                    double.tryParse(coordinatesList.last) !=
                                        null) {
                                  longituteTextEditingController.text =
                                      coordinatesList.last;
                                  FocusManager.instance.primaryFocus
                                      ?.nextFocus();
                                }

                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (mounted) {
                                    editableTextState.bringIntoView(
                                        editableTextState
                                            .textEditingValue.selection.extent);
                                  }
                                });
                                editableTextState.hideToolbar();
                                formKey.currentState!.validate();
                              },
                              // to apply the normal behavior when click on select all
                              onSelectAll: editableTextState
                                      .textEditingValue.text.isNotEmpty
                                  ? () => editableTextState
                                      .selectAll(SelectionChangedCause.toolbar)
                                  : null,
                            );
                          },
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                errorText: 'Поле обязательно к заполнению',
                              ),
                              (value) {
                                final myValue = double.tryParse(value!);
                                if (myValue != null) {
                                  return myValue.isFinite && myValue.abs() <= 90
                                      ? null
                                      : 'Введите валидное значение широты';
                                }
                                return null;
                              }
                            ],
                          ),
                          //  (value) {
                          //   FormBuilderValidators.compose(
                          //     [
                          //       FormBuilderValidators.required(
                          //         errorText: 'Поле обязательно к заполнению',
                          //       ),
                          //       // (value) {
                          //       //   final myValue =
                          //       //       double.tryParse(value! as String);
                          //       //   if (myValue != null) {
                          //       //     return myValue.isFinite &&
                          //       //             myValue.abs() <= 90
                          //       //         ? null
                          //       //         : 'Введите валидное значение широты';
                          //       //   }
                          //       //   return null;
                          //       // }
                          //     ],
                          //   );
                          //   return null;

                          //   //isFinite(num) && Math.abs(num) <= 90
                          // },
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.red,
                              ),
                              gapPadding: 4,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            errorMaxLines: 2,
                            isCollapsed: false,
                            isDense: false,
                            hintText: 'пр.: 59.93015',
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.red,
                              ),
                              gapPadding: 4,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              gapPadding: 4,
                              borderSide: const BorderSide(
                                width: 3,
                                color: grayscaleOffBlack,
                              ),
                            ),

                            floatingLabelStyle: TextStyle(
                              color: grayscaleLabel,
                              fontSize: 18.sp,
                            ),

                            filled: true,
                            fillColor: grayscaleInput,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            //hintStyle: TextStyle()
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Долгота',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          contextMenuBuilder: (context, editableTextState) {
                            return AdaptiveTextSelectionToolbar.editable(
                              anchors: editableTextState.contextMenuAnchors,
                              clipboardStatus:
                                  editableTextState.clipboardStatus.value,
                              onCopy: editableTextState
                                      .textEditingValue.text.isNotEmpty
                                  ? () {
                                      editableTextState.copySelection(
                                          SelectionChangedCause.toolbar);
                                    }
                                  : null,
                              // to apply the normal behavior when click on cut
                              onCut: editableTextState
                                      .textEditingValue.text.isNotEmpty
                                  ? () => editableTextState.cutSelection(
                                      SelectionChangedCause.toolbar)
                                  : null,
                              onPaste: () async {
                                // HERE will be called when the paste button is clicked in the toolbar
                                // apply your own logic here
                                if (editableTextState.widget.readOnly) {
                                  return;
                                }
                                final TextSelection selection =
                                    editableTextState
                                        .textEditingValue.selection;
                                if (!selection.isValid) {
                                  return;
                                }
                                // Snapshot the input before using `await`.
                                // See https://github.com/flutter/flutter/issues/11427
                                final ClipboardData? data =
                                    await Clipboard.getData(
                                        Clipboard.kTextPlain);
                                if (data == null) {
                                  return;
                                }

                                // After the paste, the cursor should be collapsed and located after the
                                // pasted content.
                                final int lastSelectionIndex = math.max(
                                    selection.baseOffset,
                                    selection.extentOffset);
                                final TextEditingValue
                                    collapsedTextEditingValue =
                                    editableTextState.textEditingValue.copyWith(
                                  selection: TextSelection.collapsed(
                                      offset: lastSelectionIndex),
                                );
                                //lastSelectionIndex,lastSelectionIndex2
                                //59.930484606271804,30.360877635084904
                                final coordinatesList = data.text!.split(',');
                                editableTextState.userUpdateTextEditingValue(
                                  collapsedTextEditingValue.replaced(
                                    selection,
                                    coordinatesList.last,
                                  ),
                                  SelectionChangedCause.toolbar,
                                );
                                //Обовляем второе поле с долготой, если список состоит из двух значений
                                if (coordinatesList.length > 1 &&
                                    double.tryParse(coordinatesList.first) !=
                                        null) {
                                  latitudeTextEditingController.text =
                                      coordinatesList.first;
                                }

                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (mounted) {
                                    editableTextState.bringIntoView(
                                        editableTextState
                                            .textEditingValue.selection.extent);
                                  }
                                });
                                editableTextState.hideToolbar();
                                formKey.currentState!.validate();
                              },
                              // to apply the normal behavior when click on select all
                              onSelectAll: editableTextState
                                      .textEditingValue.text.isNotEmpty
                                  ? () => editableTextState
                                      .selectAll(SelectionChangedCause.toolbar)
                                  : null,
                            );
                          },
                          controller: longituteTextEditingController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          inputFormatters: [
                            formatter,
                            LengthLimitingTextInputFormatter(
                              14,
                            )
                          ],
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(
                                errorText: 'Поле обязательно к заполнению',
                              ),
                              (value) {
                                final myValue = double.tryParse(value!);
                                if (myValue != null) {
                                  return myValue.isFinite &&
                                          myValue.abs() <= 180
                                      ? null
                                      : 'Введите валидное значение широты';
                                }
                                return null;
                              }
                            ],
                          ),
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.red,
                              ),
                              gapPadding: 4,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            errorMaxLines: 2,
                            isCollapsed: false,
                            isDense: false,
                            hintText: 'пр.: 179.23010',
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 3,
                                color: Colors.red,
                              ),
                              gapPadding: 4,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              gapPadding: 4,
                              borderSide: const BorderSide(
                                width: 3,
                                color: grayscaleOffBlack,
                              ),
                            ),

                            floatingLabelStyle: TextStyle(
                              color: grayscaleLabel,
                              fontSize: 18.sp,
                            ),

                            filled: true,
                            fillColor: grayscaleInput,

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            //hintStyle: TextStyle()
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  var isFormValid = formKey.currentState!.validate();
                  if (isFormValid) {
                    context.popRoute();
                    widget.mapController.move(
                      LatLng(
                        double.parse(latitudeTextEditingController.text),
                        double.parse(longituteTextEditingController.text),
                      ),
                      widget.mapController.zoom,
                    );
                  }
                },
                child: const Text('Перейти к заданной локации'))
          ],
        ),
      ),
    );
  }
}

class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const FloatingModal({Key? key, required this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }
}
