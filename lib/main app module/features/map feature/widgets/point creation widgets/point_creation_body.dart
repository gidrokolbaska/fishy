import 'package:fishy/constants.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'day_night_changer_widget.dart';
import 'point_creation_list_tile.dart';

class PointCreationBody extends StatelessWidget {
  PointCreationBody({
    super.key,
  });
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:
          const EdgeInsets.only(left: 7.0, right: 7.0, top: 7.0, bottom: 7.0),
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            autocorrect: false,
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
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          autocorrect: false,
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
          onTap: () {},
        ),
        const PointCreationListTile(
          title: 'Время суток',
          showTrailing: false,
          subtitle: DayNightChangerWidget(),
        ),
        PointCreationListTile(
          title: 'Глубина',
          onTap: () {},
        ),
        PointCreationListTile(
          title: 'Вид дна',
          onTap: () {},
        ),
        PointCreationListTile(
          title: 'Вид ловли',
          shouldShowUnderlineBorder: false,
          onTap: () {},
        ),
      ],
    );
  }
}
