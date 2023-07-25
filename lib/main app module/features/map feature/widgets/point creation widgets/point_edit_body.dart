import 'dart:async';

import 'package:chips_choice/chips_choice.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/point_creation_providers.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/views/point_creation_depth_view.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/views/point_creation_type_of_fishing_view.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/views/point_creation_type_of_location_view.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/views/point_edit_photos_view.dart';
import 'package:fishy/models/fishy_point_model.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';

import '../../views/point_creation_type_of_bottom_fishing_view.dart';
import 'custom_date_picker.dart';
import 'day_night_changer_widget.dart';
import 'point_creation_list_tile.dart';
import 'point_edit_list_tile.dart';
import 'point_edit_location_picker.dart';

class PointEditBody extends ConsumerStatefulWidget {
  const PointEditBody({
    super.key,
    required this.controller,
    required this.point,
  });
  final AnimationController controller;
  final PointModel point;

  @override
  ConsumerState<PointEditBody> createState() => _PointEditBodyState();
}

class _PointEditBodyState extends ConsumerState<PointEditBody> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(selectedPhotosListProvider.notifier).update(null);
      ref
          .read(dateProvider.notifier)
          .update(widget.point.dateOfFishing.toDate());
      ref
          .read(typeOfLocationSelectedChoicesProvider.notifier)
          .update(widget.point.typeOfLocation.cast<String>().toList());
      ref.read(dayNightProvider.notifier).update((state) => widget.point.isDay);
      ref
          .read(markerIconProvider.notifier)
          .update((state) => widget.point.markerIcon);
      ref
          .read(markerColorProvider.notifier)
          .update((state) => widget.point.markerColor);
      ref.read(depthProvider.notifier).update(widget.point.depth);
      ref
          .read(typeOfBottomSelectedChoicesProvider.notifier)
          .update(widget.point.typeOfDepth.cast<String>().toList());
      ref
          .read(typeOfFishingSelectedChoicesProvider.notifier)
          .update(widget.point.typeOfFishing.cast<String>().toList());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nameController = ref.watch(positionNameProvider);
    final descriptionController = ref.watch(positionDescriptionProvider);
    return ListView(
      controller: ModalScrollController.of(context),
      // physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding:
          const EdgeInsets.only(left: 7.0, right: 7.0, top: 7.0, bottom: 7.0),
      children: [
        TextFormField(
          autocorrect: false,
          controller: nameController..text = widget.point.positionName,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            errorMaxLines: 2,
            isCollapsed: false,
            isDense: false,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            filled: true,
            fillColor: grayscaleInput,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16.0),
            ),
            prefixIconColor: grayscaleOffBlack,
            prefixIcon: const Icon(
              FishyIcons.scroll,
            ),
            hintText: 'Введите название позиции',
          ),
          validator: FormBuilderValidators.required(),
        )
            .animate(
              autoPlay: false,
              controller: widget.controller,
              onComplete: (controller) {
                controller.reset();
              },
            )
            .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1))
            .shake(hz: 25, curve: Curves.fastOutSlowIn),
        const SizedBox(
          height: 16,
        ),
        TextField(
          autocorrect: false,
          controller: descriptionController
            ..text = widget.point.positionDescription ?? '',
          expands: false,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
            isCollapsed: false,
            isDense: false,
            filled: true,
            fillColor: grayscaleInput,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16.0),
            ),
            prefixIconColor: grayscaleOffBlack,
            hintText: 'Описание позиции',
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FishyIcons.gps,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              width: 9,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final coordinates = ref.watch(fishyCoordinatesProvider);
                  return coordinates == null
                      ? Text(
                          '${widget.point.latitude.toStringAsFixed(6)}, ${widget.point.longitude.toStringAsFixed(6)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        )
                      : Text(
                          '${coordinates.latitude.toStringAsFixed(6)}, ${coordinates.longitude.toStringAsFixed(6)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        );
                },
              ),
            ),
            TextButton(
              onPressed: () async {
                await CupertinoScaffold.showCupertinoModalBottomSheet<void>(
                  expand: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  shadow: const BoxShadow(color: Colors.transparent),
                  builder: (context) => PointEditLocationPicker(
                    point: widget.point,
                    ref: ref,
                  ),
                );
              },
              child: const Text(
                'Изменить',
              ),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        InternetConnectionChecker(
          amountOfExistingFirebaseImages: widget.point.photoURLs?.length ?? 0,
          shouldCountExistingFirebaseImages: widget.point.photoURLs != null &&
              widget.point.photoURLs!.isNotEmpty,
          urls: widget.point.photoURLs?.cast<String>() ?? [],
          ref: ref,
        ),
        PointCreationListTile(
          title: 'Тип локации',
          provider: typeOfLocationSelectedChoicesProvider,
          onTap: () {
            CupertinoScaffold.showCupertinoModalBottomSheet<void>(
              expand: false,
              context: context,
              backgroundColor: Colors.transparent,
              shadow: const BoxShadow(color: Colors.transparent),
              builder: (context) => TypeOfLocationBottomSheetPage(
                ref: ref,
              ),
            );
          },
        ),
        PointCreationListTile(
          title: 'Дата рыбалки',
          provider: dateProvider,
          onTap: () async {
            var initialDate = ref.read(dateProvider);
            await showCustomDatePicker(
              context: context,
              initialDate: initialDate!,
              firstDate: DateTime(DateTime.now().year - 2),
              lastDate: DateTime.now(),
              borderRadius: 15,
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              helperStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
              titleStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
              headerStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            );
          },
        ),
        PointCreationListTile(
          title: 'Время суток',
          showTrailing: false,
          subtitle: DayNightChangerWidget(
            isDay: widget.point.isDay,
          ),
        ),
        const PointCreationListTile(
          title: 'Иконка маркера',
          showTrailing: false,
          subtitle: SizedBox(
            height: 80,
            child: FishyPointIconSelector(),
          ),
        ),
        const PointCreationListTile(
          title: 'Цвет маркера',
          showTrailing: false,
          subtitle: SizedBox(
            height: 80,
            child: FishyPointColorSelector(),
          ),
        ),
        PointCreationListTile(
          title: 'Глубина',
          provider: depthProvider,
          onTap: () async {
            await showDialog<double?>(
              context: context,
              builder: (context) {
                return const DepthSelectorView();
              },
            );
          },
        ),
        PointCreationListTile(
          title: 'Вид дна',
          provider: typeOfBottomSelectedChoicesProvider,
          onTap: () {
            CupertinoScaffold.showCupertinoModalBottomSheet<void>(
              expand: false,
              context: context,
              backgroundColor: Colors.transparent,
              shadow: const BoxShadow(color: Colors.transparent),
              builder: (context) => TypeOfBottomBottomSheetPage(
                ref: ref,
              ),
            );
          },
        ),
        PointCreationListTile(
          title: 'Вид ловли',
          shouldShowUnderlineBorder: false,
          provider: typeOfFishingSelectedChoicesProvider,
          onTap: () {
            CupertinoScaffold.showCupertinoModalBottomSheet<void>(
              expand: false,
              context: context,
              backgroundColor: Colors.transparent,
              shadow: const BoxShadow(color: Colors.transparent),
              builder: (context) => TypeOfFishingBottomSheetPage(
                ref: ref,
              ),
            );
          },
        ),
      ],
    );
  }
}

class FishyPointIconSelector extends ConsumerStatefulWidget {
  const FishyPointIconSelector({
    super.key,
  });

  @override
  ConsumerState<FishyPointIconSelector> createState() =>
      _FishyPointIconSelectorState();
}

class _FishyPointIconSelectorState
    extends ConsumerState<FishyPointIconSelector> {
  @override
  Widget build(BuildContext context) {
    final tag = ref.watch(markerIconProvider);
    return ChipsChoice<int>.single(
      wrapped: true,
      alignment: WrapAlignment.spaceEvenly,
      runAlignment: WrapAlignment.spaceEvenly,
      wrapCrossAlignment: WrapCrossAlignment.center,
      padding: EdgeInsets.zero,
      value: tag,
      onChanged: (val) => ref.read(markerIconProvider.notifier).state = val,
      choiceBuilder: (item, i) {
        return CustomChip(
          iconData: iconOptions[i],
          onSelect: item.select!,
          selected: item.selected,
          height: 50,
          width: 50,
        );
      },
      choiceItems: C2Choice.listFrom<int, IconData>(
        source: iconOptions,
        value: (i, v) => i,
        label: (i, v) => v.codePoint.toString(),
      ),
    );
  }
}

class FishyPointColorSelector extends ConsumerStatefulWidget {
  const FishyPointColorSelector({
    super.key,
  });

  @override
  ConsumerState<FishyPointColorSelector> createState() =>
      _FishyPointColorSelectorState();
}

class _FishyPointColorSelectorState
    extends ConsumerState<FishyPointColorSelector> {
  @override
  Widget build(BuildContext context) {
    final tag = ref.watch(markerColorProvider);
    return ChipsChoice<int>.single(
      wrapped: true,
      alignment: WrapAlignment.spaceEvenly,
      runAlignment: WrapAlignment.spaceEvenly,
      wrapCrossAlignment: WrapCrossAlignment.center,
      padding: EdgeInsets.zero,
      value: tag,
      onChanged: (val) => ref.read(markerColorProvider.notifier).state = val,
      choiceBuilder: (item, i) {
        return CustomChip2(
          color: colorOptions[i],
          onSelect: item.select!,
          selected: item.selected,
          height: 50,
          width: 50,
        );
      },
      choiceItems: C2Choice.listFrom<int, Color>(
        source: colorOptions,
        value: (i, v) => i,
        label: (i, v) => v.value.toString(),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final IconData iconData;
  final Color? color;
  final double? width;
  final double? height;
  final bool selected;

  final Function(bool selected) onSelect;
  const CustomChip({
    Key? key,
    required this.iconData,
    this.color,
    this.width,
    this.height,
    this.selected = false,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      width: width,
      height: height,
      duration: const Duration(milliseconds: 300),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          strokeAlign: BorderSide.strokeAlignOutside,
          color: selected
              ? (color ?? theme.colorScheme.primary)
              : theme.colorScheme.onSurface.withOpacity(.38),
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: () => onSelect(!selected),
        child: Icon(
          iconData,
          color: selected ? theme.colorScheme.primary : null,
        ),
      ),
    );
  }
}

class CustomChip2 extends StatelessWidget {
  final Color color;
  final double? width;
  final double? height;
  final bool selected;

  final Function(bool selected) onSelect;
  const CustomChip2({
    Key? key,
    required this.color,
    this.width,
    this.height,
    this.selected = false,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      alignment: Alignment.center,
      width: width,
      height: height,
      duration: const Duration(milliseconds: 300),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          strokeAlign: BorderSide.strokeAlignOutside,
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(.38),
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        onTap: () => onSelect(!selected),
        child: Ink(
          width: 45,
          height: 45,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: color,
          ),
        ),
      ),
    );
  }
}

class InternetConnectionChecker extends StatefulWidget {
  const InternetConnectionChecker({
    super.key,
    required this.shouldCountExistingFirebaseImages,
    required this.amountOfExistingFirebaseImages,
    required this.urls,
    required this.ref,
  });
  final bool shouldCountExistingFirebaseImages;
  final int amountOfExistingFirebaseImages;
  final List<String> urls;
  final WidgetRef ref;
  @override
  State<InternetConnectionChecker> createState() =>
      _InternetConnectionCheckerState();
}

class _InternetConnectionCheckerState extends State<InternetConnectionChecker> {
  bool enabled = true;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      setState(() {
        enabled = true;
      });
    } else {
      setState(() {
        enabled = false;
      });
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PointEditListTile(
      title: 'Фотографии',
      provider: selectedPhotosListProvider,
      enabled: enabled,
      shouldCountExistingFirebaseImages:
          widget.shouldCountExistingFirebaseImages,
      amountOfExistingFirebaseImages: widget.amountOfExistingFirebaseImages,
      onTap: () {
        CupertinoScaffold.showCupertinoModalBottomSheet<void>(
          expand: true,
          context: context,
          backgroundColor: Colors.transparent,
          shadow: const BoxShadow(color: Colors.transparent),
          builder: (context) => PhotosEditBottomSheetPage(
            imagesUrl: widget.ref.read(selectedOnlinePhotosListProvider) ??
                widget.urls,
          ),
        );
      },
    );
  }
}
