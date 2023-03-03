import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/point_creation_providers.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/views/point_creation_depth_view.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/views/point_creation_type_of_fishing_view.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'custom_date_picker.dart';
import 'day_night_changer_widget.dart';
import 'point_creation_list_tile.dart';

class PointCreationBody extends ConsumerStatefulWidget {
  const PointCreationBody({
    super.key,
    required this.controller,
  });
  final AnimationController controller;
  @override
  ConsumerState<PointCreationBody> createState() => _PointCreationBodyState();
}

class _PointCreationBodyState extends ConsumerState<PointCreationBody>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  @override
  void initState() {
    super.initState();
    nameController = ref.read(positionNameProvider);
    descriptionController = ref.read(positionDescriptionProvider);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: ModalScrollController.of(context),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding:
          const EdgeInsets.only(left: 7.0, right: 7.0, top: 7.0, bottom: 7.0),
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            autocorrect: false,
            controller: nameController,
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
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          autocorrect: false,
          controller: descriptionController,
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
        PointCreationListTile(
          title: 'Фотографии',
          onTap: () {},
        ),
        PointCreationListTile(
          title: 'Тип локации',
          onTap: () {},
        ),
        PointCreationListTile(
          title: 'Дата рыбалки',
          provider: dateProvider,
          onTap: () async {
            final initialDate = ref.read(dateProvider);

            await showCustomDatePicker(
              context: context,
              initialDate: initialDate ?? DateUtils.dateOnly(DateTime.now()),
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
        const PointCreationListTile(
          title: 'Время суток',
          showTrailing: false,
          subtitle: DayNightChangerWidget(),
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
          onTap: () {},
        ),
        PointCreationListTile(
          title: 'Вид ловли',
          shouldShowUnderlineBorder: false,
          onTap: () {
            CupertinoScaffold.showCupertinoModalBottomSheet<void>(
              context: context,
              backgroundColor: Colors.transparent,
              shadow: const BoxShadow(color: Colors.transparent),
              builder: (context) => const TypeOfFishingBottomSheetPage(),
            );
          },
        ),
      ],
    );
  }
}
